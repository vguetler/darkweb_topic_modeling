
# Ansar and islamic network topic models - 2024
# use cleaned data from python script folder diss script

set.seed(1001)

# load libraries
library(corpustools)
library(dplyr)
library(tidyverse)
#install.packages(c("topicmodels", "ldatuning", repos="file:///gpfs21/pub/CRAN")) 
library(topicmodels)
library(lda)
library(ldatuning) #error
library(quanteda)
#install.packages("quanteda.textplots")
library(quanteda.textplots)
library(openxlsx)
library(lsa)
library(igraph) 
library(parallel)
library(broom)
#install.packages("tm")
library(reshape2)
library(ggplot2)
#install.packages("wordcloud")
library(wordcloud)
#install.packages("pals")
library(pals)
#install.packages("SnowballC")
library(SnowballC)
#install.packages("xlsx") error java
library(ggraph)
#install.packages("Rmpfr")
#library("Rmpfr")
#install.packages(c("readxl","writexl")) 
library(readxl)
library(writexl)
#install.packages("tidytext")
library(tidytext)
library(tm)

# Load data

#ansar 22313 obs
#islamicnetwork 91874 obs
#myiwc_clean3 24900 obs

# network function

network_from_LDA<-function(LDAobject,deleted_topics=c(),topic_names=c(),save_filename="",topic_size=c(),bbone=FALSE) {
  # Importing needed packages
  require(lsa) # for cosine similarity calculation
  require(dplyr) # general utility
  require(igraph) # for graph/network managment and output
  require(corpustools)
  
  print("Importing model")
  
  # first extract the theta matrix form the topicmodel object
  theta<-LDAobject@gamma
  # adding names for culumns based on k
  colnames(theta)<-c(1:LDAobject@k)
  
  # claculate the adjacency matrix using cosine similarity on the theta matrix
  mycosine<-cosine(as.matrix(theta))
  colnames(mycosine)<-colnames(theta)
  rownames(mycosine)<-colnames(theta)
  
  # Convert to network - undirected, weighted, no diagonal
  
  print("Creating graph")
  
  topmodnet<-graph.adjacency(mycosine,mode="undirected",weighted=T,diag=F,add.colnames="label") # Assign colnames
  # add topicnames as name attribute of node - importend from prepare meta data in previous lines
  if (length(topic_names)>0) {
    print("Topic names added")
    V(topmodnet)$name<-topic_names
  } 
  # add sizes if passed to funciton
  if (length(topic_size)>0) {
    print("Topic sizes added")
    V(topmodnet)$topic_size<-topic_size
  }
  newg<-topmodnet
  
  # delete 'garbage' topics
  if (length(deleted_topics)>0) {
    print("Deleting requested topics")
    
    newg<-delete_vertices(topmodnet, deleted_topics)
  }
  
  # Backbone
  if (bbone==TRUE) {
    print("Backboning")
    
    nnodesBASE<-length(V(newg))
    for (bbonelvl in rev(seq(0,1,by=0.05))) {
      #print (bbonelvl)
      nnodes<-length(V(backbone_filter(newg,alpha=bbonelvl)))
      if(nnodes>=nnodesBASE) {
        bbonelvl=bbonelvl
        #  print ("great")
      }
      else{break}
      oldbbone<-bbonelvl
    }
    
    newg<-backbone_filter(newg,alpha=oldbbone)
    
  }
  
  # run community detection and attach as node attribute
  print("Calculating communities")
  
  mylouvain<-(cluster_louvain(newg)) 
  mywalktrap<-(cluster_walktrap(newg)) 
  myspinglass<-(cluster_spinglass(newg)) 
  myfastgreed<-(cluster_fast_greedy(newg)) 
  myeigen<-(cluster_leading_eigen(newg)) 
  
  V(newg)$louvain<-mylouvain$membership 
  V(newg)$walktrap<-mywalktrap$membership 
  V(newg)$spinglass<-myspinglass$membership 
  V(newg)$fastgreed<-myfastgreed$membership 
  V(newg)$eigen<-myeigen$membership 
  
  # if filename is passsed - saving object to graphml object. Can be opened with Gephi.
  if (nchar(save_filename)>0) {
    print("Writing graph")
    write.graph(newg,paste0(save_filename,".graphml"),format="graphml")
  }
  
  # graph is returned as object
  return(newg)
}

#data preprocess - 

#df_ansar <- ansar %>%
  #select(MemberName, Message, ThreadID, ThreadName, P_Year)

#message col name text
df_ansar$text <- df_ansar$Message


# removed short text <300, could also change to original <600

## we are adding index to be able to match documents across data types. 
df_ansar$index <-seq(1:nrow(df_ansar))

### removing extremely short documents.
removed_short<-subset(df_ansar,nchar(as.character(df_ansar$text))<600) #original script was <600, 11690 obs

df2<-subset(df_ansar,!nchar(as.character(df_ansar$text))<600) 

### removing duplicate documents
removed_df<-df2[duplicated(df2$text),] #62 messages was duplicated, 
df3 <- df2[!duplicated(df2$text),] 
df3

### Text Pre-processing
##### import data to quanteda format

mycorpus <- corpus(df3)

view(mycorpus) #12705 documents

# summary of corpus
#summary(mycorpus) # output too long but shows text, types, tokens, sentences, membername etc

summary(mycorpus, n = 5)

# remove stopwords
##### using quanteda stopwords, with single letters as well
stopwords_and_single<-c(stopwords("english"),LETTERS,letters)

# Preparing dfm object. Did not stem, bigram?? and remove numbers, symbols and English standard stop words.
##### preparing dfm object. No stemming due to its impact on topic quality

dfm_counts <- dfm(mycorpus,tolower = TRUE, remove_punct = TRUE,remove_numbers=TRUE, 
                  remove = stopwords_and_single,stem = FALSE, remove_symbols =TRUE,
                  remove_separators=TRUE) 

##### trimming tokens too common or too rare to improve efficiency of modeling

dfm_counts2<-dfm_trim(dfm_counts, max_docfreq = 0.99, min_docfreq=0.005,docfreq_type="prop")

# view the dfm stats
dfm_counts2 #9094 documents


# wordcloud of frequent words
#top40words <- sort(tmResult$terms[topicToViz,], decreasing=TRUE)[1:40]
#mycolors <- brewer.pal(8, "Dark2")
#wordcloud(dfm_counts2, random.order = FALSE, color = mycolors)

set.seed(150)
textplot_wordcloud(dfm_counts2)

##### converting to LDA ready object

#dtm_lda2 <- convert(dfm_counts, to = 'topicmodels') #this has the 12705 obs

#dtm_lda <- convert(dfm_counts2, to = "topicmodels", omit_empty = FALSE)
#dtm_lda  #changed to 12704 documents, adding omit_empty = False returned to 12705

dtm_lda <- convert(dfm_counts2, to = "topicmodels")
dtm_lda 

# running the model
LDA.42<- LDA(dtm_lda, k=42, method = "Gibbs")
LDA.42

# extracting excel matrices for topic interpretation
LDAfit<-LDA.42

mybeta<-data.frame(LDAfit@beta)
colnames(mybeta)<-LDAfit@terms
mybeta<-t(mybeta)
colnames(mybeta)<-seq(1:ncol(mybeta))
mybeta=exp(mybeta)

### First we print top 50 words
nwords=50
topwords <- mybeta[1:nwords,]
for (i in 1:LDAfit@k) {
  tempframe <- mybeta[order(-mybeta[,i]),]
  tempframe <- tempframe[1:nwords,]
  tempvec<-as.vector(rownames(tempframe))
  topwords[,i]<-tempvec
}
rownames(topwords)<-c(1:nwords)

#write.xlsx(topwords, "TopWords.xlsx") 
write.csv(topwords, "AnsarTopWords2024.csv") 

### Print top 30 documents
metadf<-df3

# notice that the "text" column is again named "text". If column name is different, name "text" needs to be changed.

meta_theta_df<-cbind(metadf[,"text"],LDAfit@gamma) #didnt work error, skipping
ntext=30
toptexts <- mybeta[1:ntext,]
for (i in 1:LDAfit@k) {
  print(i)
  tempframe <- meta_theta_df[order(-as.numeric(meta_theta_df[,i+1])),]
  tempframe <- tempframe[1:ntext,]
  tempvec<-as.vector(tempframe[,1])
  toptexts[,i]<-tempvec
}
rownames(toptexts)<-c(1:ntext)

#write.xlsx(toptexts, "TopTexts.xlsx") 
write.csv(toptexts, "AnsarTopTexts2024.csv") 

### Extrating unique words for topic (FREX words)
mybeta<-data.frame(LDAfit@beta)
colnames(mybeta)<-LDAfit@terms
mybeta<-t(mybeta)
colnames(mybeta)<-seq(1:ncol(mybeta))
mybeta=exp(mybeta)

# change myw to change the weight given to uniqueness
myw=0.3
word_beta_sums<-rowSums(mybeta)
my_beta_for_frex<-mybeta
for (m in 1:ncol(my_beta_for_frex)) {
  for (n in 1:nrow(my_beta_for_frex)) {
    my_beta_for_frex[n,m]<-1/(myw/(my_beta_for_frex[n,m]/word_beta_sums[n])+((1-myw)/my_beta_for_frex[n,m]))
  }
  print (m)
}
nwords=50
topfrex <- my_beta_for_frex[1:nwords,]
for (i in 1:LDAfit@k) {
  tempframe <- my_beta_for_frex[order(-my_beta_for_frex[,i]),]
  tempframe <- tempframe[1:nwords,]
  tempvec<-as.vector(rownames(tempframe))
  topfrex[,i]<-tempvec
}
rownames(topfrex)<-c(1:nwords)

#write.xlsx(topfrex, "TopFREXWords.xlsx")
write.csv(topfrex, "AnsarTopFrexWords2024.csv")

# Creating the network
# Labeling 42 topics using representative full text 
# skip topics 9, 17, 18, 22, 39, 40

ansarnames <- c('Fighting',	'Somalia Islamist Group',	'American Attack', 'Russia Attacks',	
                'Terror Attacks', 'Terrorism News', 'Mujahideen',	'Bomb Attacks', 'Extra9',
                'Al-Qaeda', 'Police',	'Guantanamo Prisoners', 'Intelligence', 'Israel & Palestine', 
                'Death Reports', 'Taliban & Afghan',	'Extra17',	'Extra18',	
                'Pakistan Taliban', 'Islam & Jihad',	'Deaths', 'Extra22', 
                'Swat Taliban', 'Troops', 'President Obama', 'Mujahideen Supporters', 'Al-Qaeda Saudi Attacks',
                'Iran', 'Killed Soldiers',	'Soldiers', 'Jihad', 
                'News',	'Kidnappings & Ransoms',	'Iraq, Sunni & Insurgency', 
                'Arrests & Convictions', 'Politics',	'Jihadi Videos',	'Militants', 'Extra39',	
                'Extra40', 'Weapons', 'Muslims')


# ceate the network

### using the network from LDA function:
ansarnet <-network_from_LDA(LDAobject=LDAfit,
                            #deleted_topics=c(15, 16, 31, 37, 65),
                            deleted_topics = c(9, 17, 18, 22, 39, 40),
                            topic_names= ansarnames,
                            save_filename="ansartopics",
                            bbone=FALSE)

# We can also add the size of topics to the node attribute. In our example to improve model quality we removed duplicate entries
LDAfit<-LDA.42
dfm_forsize<-data.frame(dfm_counts2)
dfm_forsize<-dfm_forsize[,-1]
sizevect<-rowSums(dfm_forsize)
meta_theta_df<-data.frame(size=sizevect,LDAfit@gamma)

topic.frequency <- colSums(meta_theta_df[,2:ncol(meta_theta_df)]*as.vector(meta_theta_df[,1]))
topic.proportion <- topic.frequency/sum(topic.frequency)

ansarnet2<-network_from_LDA(LDAobject=LDAfit,
                            deleted_topics=c(9, 17, 18, 22, 39, 40),
                            topic_names=ansarnames,
                            save_filename="ansartopicsbysize",
                            topic_size = topic.proportion)
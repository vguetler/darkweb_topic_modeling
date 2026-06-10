
# Dark Web Topic Modeling Analysis of Jihadists' Forums

> This research applies Latent Dirichlet Allocation (LDA) and social network analysis to text from jihadist dark web forums to identify topic clusters and network structures relevant to cyber threat intelligence.

---

## 📌 Overview

> This project analyzes three Dark Web forums of terrorist groups and their supporters accessed from the University of Arizona Artificial Intelligence Lab’s Dark Web Forums. The forums include Ansar1, an English language
forum with 29,492 posts and 11,244 threads, 382 members between 12/8/2008 and 1/20/2010. Gawaher is an English-language Islamic forum dedicated to discussing the Islamic world and Islamic issues. Some of the forum members sympathize with radical Islamic groups. This forum entails 372,499 posts and 53,235 threads made by 9,269 members between 10/24/2004 and 6/7/2012. The Islamic Network forum is dedicated to a range of topics of interest to Muslims, from theology to world events. Some members sympathize with and support terrorists. This forum has 91,874 posts and 13,995 threads created by 2,082 members between 6/9/2004 and 11/10/2010.

> Using natural language processing techniques, specifically latent Dirichlet allocation (LDA) topic models (Blei, 2012; Blei et al., 2003) and social/topic network analysis (Walter & Ophir, 2019), it identifies the dominant discourse themes and key network actors. Findings were presented at PyCon 2024 and inform ongoing work on computational methods for cyber threat detection.


---


## 🔧 Setup & installation

**Python version:** 3.10+  
**Key dependencies:** 
- `gensim` — LDA topic modeling
- `bertopic` — transformer-based topic modeling
- `networkx` — social network analysis
- `pandas`, `matplotlib`, `seaborn` — data wrangling and visualization

---

## 📊 Data

> ⚠️ **Note on sensitive data:** 

Data not included (sensitive/proprietary):
> Raw data is not included in this repository due to [ethical/legal/sensitivity reasons]. The `data/processed/` folder contains an anonymized sample sufficient to reproduce the core analysis. Contact vguetler@gmail.com for more information.


---

## 🔍 Methods

Briefly describe your analytical pipeline. Example:

1. **Preprocessing** — tokenization, stopword removal, lemmatization using spaCy
2. **Topic modeling** — LDA (Gensim) with coherence score optimization; [N] topics identified
3. **Network construction** — co-author/co-mention network built with NetworkX; analyzed for degree centrality, betweenness, and modularity
4. **Validation** — [how you validated results: human coding, perplexity scores, etc.]

---

## 📈 Key findings

Summarize 3–5 bullet points of what you found. Write for a policy/practitioner audience, not just a technical one.

- Finding 1 — e.g., "Topic cluster X dominated [X]% of posts and was associated with operational planning language"
- Finding 2 - The topic model for the Ansar1 Dark Web forum consisted of 80 topics and two communities or clusters (in red and blue). The topics labeled ‘Mujahideen Media’ and ‘Scriptures’ were the most prevalent in this forum.
- Finding 3 - The Gawaher forum has 67 topics and two communities; the largest community in green topics is primarily about religion, Islamic scripture, the Bible vs. Quran, converting to Islam, and non-Muslims
- The Islamic Network forum resulted in 72 labeled topics and 3 topic clusters. The topics in green discussed Guantanamo Bay and how prisoners are tortured and interrogated in that prison. The topics in red/orange were a mix of electronics sold on the
Dark Web, jihad, religion, the discussion on nationalism, investments, and money, advertisements selling fake documents, and IDs.

- In sum, some forum members sympathize with and support terrorist organizations. Religion is the most prevalent topic in all forums. Other topics include terrorism, terror attacks, support for the Mujahideen fighters, relationships, selling electronics, and fake identity cards. Implications for counterterrorism include topic modeling in real-time classification, removal of online terrorist content, and monitoring religious forums, as terrorist groups use religion to justify their goals and recruitment.

<img width="1024" height="1024" alt="image" src="https://github.com/user-attachments/assets/1973dffb-4e2b-467e-85e6-2fe9c18efaf7" />

<img width="1024" height="1024" alt="image" src="https://github.com/user-attachments/assets/3644955d-b876-443a-843f-4d16d485a1b4" />

<img width="1024" height="1024" alt="image" src="https://github.com/user-attachments/assets/b874aee2-8e41-4583-a0b2-23f0797bc4b7" />


---

## 📄 Related publications & presentations

- [Paper title] — *Venue*, Year — [link if available]
- [Conference presentation] — *Conference*, Year

---


---

## 📬 Contact & citation

**Vivian F. Guetler, PhD**  
Computational Social Scientist & Cybersecurity Researcher  
vguetler@gmail.com · [vguetler.github.io](https://vguetler.github.io)

If you use this code or data in your research, please cite:

```bibtex
@misc{guetler[year][shorttitle],
  author    = {Guetler, Vivian F.},
  title     = {[Full project title]},
  year      = {[year]},
  publisher = {GitHub},
  url       = {https://github.com/vguetler/[repo-name]}
}
```

---

## 📝 License

[MIT License](LICENSE) — code is freely reusable. Data licensing noted separately in `data/README.md`.

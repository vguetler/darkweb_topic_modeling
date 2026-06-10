
# Dark Web Topic Modeling Analysis of Jihadists' Forums

> This research applies Latent Dirichlet Allocation (LDA) and social network analysis to text from jihadist dark web forums to identify topic clusters and network structures relevant to cyber threat intelligence.

---

## 📌 Overview

Write 2–4 sentences here for a non-technical reader:
- **What** data or problem does this project address?
- **Why** does it matter? (policy implications, threat intelligence value, research contribution)
- **What** did you find or build?


> This project analyzes three Dark Web forums of terrorist groups and their supporters accessed from the University of Arizona Artificial Intelligence Lab’s Dark Web Forums. The forums include Ansar1, an English language
forum with 29,492 posts and 11,244 threads, 382 members between 12/8/2008 and 1/20/2010. The second forum, Gawaher, is an English-language Islamic forum dedicated to discussing the Islamic world and Islamic issues. Some of the forum
members sympathize with radical Islamic groups. This forum entails 372,499 posts and 53,235 threads made by 9,269 members between 10/24/2004 and 6/7/2012. The Islamic Network forum is dedicated to various topics of interest to Muslims, ranging
from theology and world events. Some members sympathize with and support terrorists. This forum has 91,874 posts and 13,995 threads created by 2,082 members between 6/9/2004 and 11/10/2010.

> Using natural language processing techniques, specifically latent Dirichlet allocation (LDA) topic models (Blei, 2012; Blei et al., 2003) and social/topic network analysis (Walter & Ophir, 2019), it identifies the dominant discourse themes and key network actors. Findings were presented at PyCon 2024 and inform ongoing work on computational methods for cyber threat detection.


---

## 📁 Repository structure

```
├── data/
│   ├── raw/              # Raw data (or instructions to obtain it — see Data section)
│   └── processed/        # Cleaned, anonymized data used in analysis
├── notebooks/
│   ├── 01_preprocessing.ipynb    # Data cleaning and preparation
│   ├── 02_topic_modeling.ipynb   # LDA / BERTopic analysis
│   ├── 03_network_analysis.ipynb # Social network construction and metrics
│   └── 04_visualization.ipynb   # Figures and output charts
├── src/
│   └── utils.py          # Helper functions
├── outputs/
│   └── figures/          # Saved charts and visualizations
├── requirements.txt
└── README.md
```

---

## 🔧 Setup & installation

```bash
# Clone the repo
git clone https://github.com/vguetler/[repo-name].git
cd [repo-name]

# Install dependencies
pip install -r requirements.txt

# Launch Jupyter
jupyter notebook
```

**Python version:** 3.10+  
**Key dependencies:** *(list the main ones, e.g.)*
- `gensim` — LDA topic modeling
- `bertopic` — transformer-based topic modeling
- `networkx` — social network analysis
- `pandas`, `matplotlib`, `seaborn` — data wrangling and visualization

---

## 📊 Data

> ⚠️ **Note on sensitive data:** [Choose one of the below and delete the others]

**Option A — Data not included (sensitive/proprietary):**
> Raw data is not included in this repository due to [ethical/legal/sensitivity reasons]. The `data/processed/` folder contains an anonymized sample sufficient to reproduce the core analysis. Contact vguetler@gmail.com for more information.

**Option B — Data included:**
> Data collected from [source] between [dates]. See `data/raw/README.md` for collection methodology and ethical considerations.

**Option C — Instructions to replicate collection:**
> Data was collected using [method/tool]. See `notebooks/00_data_collection.ipynb` for the full collection pipeline.

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
- Finding 2
- Finding 3

---

## 📄 Related publications & presentations

- [Paper title] — *Venue*, Year — [link if available]
- [Conference presentation] — *Conference*, Year

---

## ⚖️ Ethics & IRB

> *(Include this section for any project involving human subjects data or sensitive content)*

This project [was/was not] reviewed by an IRB. Data handling followed [university/organizational] ethical guidelines. [Any specific measures taken: anonymization, aggregation, data destruction timelines, etc.]

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

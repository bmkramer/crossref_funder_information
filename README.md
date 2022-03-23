# Crossref funder information per publisher

Funder information, provided by publishers, is one of the types of metadata included in Crossref. 
Currently, coverage of funder information varies considerably between publishers.

This repo contains data and code for querying the Crossref API for proportion of current journal articles (current year and 2 previous years) with funding information, per Crossref member ID. Data are also collected for book chapters and preprints.

At the time of sampling (March 15, 2022), **25.2% of journal articles published in 2020-2022** had funding information available in Crossref. The following figure shows the proportion of journal articles from selected major publishers published between 2020-2022 that had funding information available.

![](figures/crossref_members_funder_info.svg)

Differences between publishers could reflect:  
-  disciplinary differences in the proportion of research output resulting from (external) funding  
-  differences in proportion of research articles vs. 'paratext' (editorials, letters, etc) in journals  
-  differences in publisher/journal practices requesting funder information from authors  
-  differences in publisher systems/workflows for submitting funder information as part of Crossref metadata  


## Comparison to   

Recently, Alexis-Michel Mugabushaka, Nees Jan van Eck, Ludo Waltman looked at funding information in Crossref for Covid-19 research (arXiv: https://doi.org/10.48550/arXiv.2202.11639). Their corpus consisted of publications in the [CORD-19 dataset](https://allenai.org/data/cord-19) that were published in 2020-2021 and were included in Crossref as well as in Scopus and Web of Science. 

For this corpus, they found somewhat lower proportions of funding information in Crossref for most publishers than the proportion observed when looking at all journal articles in Crossreef for the most recent years (see figure below). 

Part of this is explained by the fact that Mugabushaka et al. looked at the presence of Fundref IDs specifically, not just the presence of funder names. In addition, observed differences could be due to specific characteristics of how and where COVID-19 research was funded and published, and/or the limitation of the subset of articles and journals also indexed in Scopus and Web of Science.    

![**Crossref coverage of funding information - comparison to Covid-19 papers in [arXiv:2202.11639](https://arxiv.org/abs/2202.11639)** ](figures/crossref_funder_info_cf_arxiv_2202_11639.svg)

* publications from 2020-2021 in the CORD-19 dataset, with Crossref DOI, that are also indexed in both Web of Science and Scopus


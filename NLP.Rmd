---
title: 'Natural Language Processing: Very Brief Introduction'
author: "Alexander Kuznetsov"
date: "April 4, 2020"
output:
  pdf_document: default
  html_document: default
---

# Natural Language Processing: Very Brief Introduction

Alexander Kuznetsov

04/02/2020

## Introduction
Text analysis is an integral part of modern analytics which plyas crucial role in many industries. Natural language processing (NLP) also requires significant hardware resources as text corpora may amount to many gigabytes in size. Therefore it is important to properly clean the text, stripping it off irrelevant characters such as punctuation, numbers, auxiliaries etc. However, even such preliminary cleanup may not be enough for huge datasets. In this case sampling text document offers easy and robust solution. This report is a brief account of downloading, cleaning, sampling and visualizing text data. Text data consists of millions of lines of text from Twitter accounts, blogs and news articles in the United States.
 
## Resources
Text data can be downloaded by clicking on this [link]( http://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip) as zip file. Although NLP is quite challenging, R has excellent, high performance tools to carry out text analysis. One such tool is open source Quanteda package available at CRAN. Detailed documentation, quick start manual and even reference to the original article can be found [here](http://quanteda.io/index.html) and [here](http://tutorials.quanteda.io). In addition to manual, Quanteda website contains useful information about text processing and covers all necessary terminology. Good luck exploring this great tool!

## Loading data, creating corpus, tokenization and more
Zip file with text data contains 3 files with corpora collected from Twitter, blogs and news media. The following commands download these files into R.

```{r}
library(quanteda)
```
```{r}
con <- file(list.files()[1], "r")
us <- readLines(con)
con <- file(list.files()[2], "r")
us <- c(us, readLines(con))
con <- file(list.files()[3], "r")
us <- c(us, readLines(con))
```
Now all 3 files are combined under one variable - **us**, saved in UTF-8 format. I found it easier to work with text data if they are in ASCII format. This is how to convert one format into another in Quanteda and create a corpus:

```{r}
usAscii <- iconv(us, from="UTF-8", to="ASCII", sub="")
corp <- corpus(usAscii)
```
Quanteda makes the above described manipulations extremely easy. However real power of this tool is in tokenization process - process in which text corpus is broken into separate words. Just couple lines of code tokenize the corpus, removing numbers, punctuation, symbols etc., and dropping stop words such as auxiliary verbs!

```{r}
toks <- tokens(corp, remove_numbers=TRUE, remove_punct=TRUE, remove_symbols=TRUE, remove_twitter=TRUE, remove_url=TRUE, remove_hyphens=TRUE)
toks1 <- tokens_remove(toks, stopwords('en'))
```
Next, n-grams can be created to prepare text for statistical analysis. For this exercise, 1- and 2-grams are going to be made, which are simply 1 and 2 word expressions from variable **toks1**.

```{r}
ngram1 <- tokens_ngrams(toks1, n=1)
length(ngram1)
ngram2 <- tokens_ngrams(toks1, n=2)
```
Quanteda offers another powerful tool - DFM, document-feature matrix where documents are recorded in rows and features - in columns. DFM allows faster and easier handling of text documents. As always, DFM can be made with one line of code.

```{r}
dfm1 <- dfm(ngram1)
dfm2 <- dfm(ngram2)
```
At last, but after just few lines of code, we can perform simple statistical analysis of the document by making word cloud plot of 1-grams.

```{r}
textplot_wordcloud(dfm1, max_words=100)
```


Unfortunately, executing above code takes long time, though Quanteda uses 2 threads to run by default. The reason is the large amount of memory that text documents occupy. In this case, the number of elements in variable **ngram1** is more than 3,000,000. Number of threads used during text processing can be set to more than 2 if needed. For example, calling function **quanteda_options(threads=3)**, sets 3 threads to run the code. However, 3 threads do not decrease processing time in any significant way. One way to go around this issue is random sampling which would yield much smaller document, but bearing the same statistical characteristics as original corpus.

## Sampling
The following code randomly samples 100,000 elements from tokenized text created earlier and stored in variable **toks1**.

```{r}
sub <- toks1[sample(1:length(toks1), 100000)]
```
Finally 1- and 2-grams can be created along with their DFMs.

```{r}
ngramSub1 <- tokens_ngrams(sub, n=1)
ngramSub2 <- tokens_ngrams(sub, n=2)
dfmSub1 <- dfm(ngramSub1)
dfmSub2 <- dfm(ngramSub2)
```
Making word cloud plots for 1- and 2-grams is quick and easy now:

```{r}
textplot_wordcloud(dfmSub1, max_words=100)
textplot_wordcloud(dfmSub2, max_words=100)
```


## Summary
Simple statistical analysis and good visualization of text data can be quickly carried out using Quanteda package. Random sampling of text corpora makes analysis much faster as size can be shrunk significantly. Word frequency analysis yields the same result for tokenized corpus of more than 3,000,000 elements as well as sampled corpus with only 100,000 words. Another interesting project could be separate analysis of word frequency in each text document related to tweets, blogs and news. Separate analysis of each corpus is going to provide different result as language used in tweets, blogs and news articles differ dramatically. Besides, corpus containing tweets is few times larger than other two. Therefore, combined text corpus is dominated by tweets. Random sampling did not change it as can be seen from the results, and that was the main goal of this small project. I am also extremely happy to see that 1-grams include significant amount of words like 'love', 'good', 'thanks'. 2-grams have word expressions like 'happy birthday', 'good luck' and 'good morning' which are definitely on positive side. However, my most favorite ones are 'happy mothers' and 'ice cream'. Although, they are not the 'fattest' words in word cloud, but I am glad they made it to first one hundred as both happy moms and ice creams are extremely important!


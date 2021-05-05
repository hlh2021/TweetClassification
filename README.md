# TweetClassification
# Abstract
Tweets classification is essential for topic selection and filtering. The highly abbreviation and noisy nature of tweets always make lower level feature, e.g. term frequency, based method challenging for accuracy classification. 
In this project, we extract and learn higher level feature from tweets for topic-based classification. The experiment results show that our hand-crafted combining keyword, named entity and term frequency features perform better than term frequency based feature. 

# Get Started

To run the code, the following environment is required: 
* MATLAB
* Java 


# Classify tweet to a pre-defined topic

The classification is implemented in MATLAB. 

We compared the performance of multiple classifiers: SVM, Random Forest, and CNN.

Entry file: testClassification.m.

# Extract entities and keywords from raw Tweets

The extraction of entities and keywords from tweets is implemented in Java with Alchemy API.

Entry file: testTweet.java.

# Dataset

Folder dataset contains all raw tweets, topic, clean content, together with entities and keywords extracted from Java end.

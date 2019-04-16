# IMPMD: An integrated method for predicting potential associations between miRNAs and diseases

## Requirements
* Matlab2016a

## File description
* There are two subfiles in the file named Feature construction for feature encoding and feature extraction.
* There are four subfolders in the folder named Predictors,which are the code of the four predictors. The predictors  are based on SVM, LR, KNN and the combination of these three algorithms, respectively.
* In the folder named Similarity is the code that calculates the enhanced similarity representation of diseases and miRNAs.
## Algorithm flow
The computational framework of the predictor. Step 1, the enhanced similarity matrixes of disease and miRNA are obtained basing on HMDD v3.0 database and MeSH. Step 2, feature vectors are constructed and extracted for miRNA-disease associations. Step 3, train the predictors obtained by SVM, KNN and LR and integrated them by linear regression. Step 4, the comprehensive predictor is applied to predict the potential miRNA-disease associations.
<img src="https://github.com/Sunmile/IMPMD/blob/master/Figures/Figure_1.png"> 
## Results
The ROC curves of different algorithm based on 10-fold cross validation. (A) the ROC curves of SVM. (B) the ROC curves of KNN. (C) the ROC curves of LR. (D) the ROC curves of comprehensive predictor.
<img src="https://github.com/Sunmile/IMPMD/blob/master/Figures/Figure_2.png"> 

Performance measures of the predictors trained by different algorithm. Four different algorithms are used to build models, namely SVM, KNN, LR and comprehensive algorithm, respectively.
<img src="https://github.com/Sunmile/IMPMD/blob/master/Figures/Figure_3.png"> 

Computational flow chart of miRNA functional similarity. Step 1, find out the diseases set (diseases associated with miRNA r_i and diseases associated with miRNA r_j, respectively). Step 2, calculate the semantic similarity between each disease in one disease set and each disease in another disease set. Step 3, find out the max semantic similarity for every disease. Step 4, calculate the functional similarity.
<img src="https://github.com/Sunmile/IMPMD/blob/master/Figures/Figure_4.png"> 

The disease DAGs of Cerebral Infarction and Alzheimer Disease. (A) The addresses of Cerebral Infarction and its ancestor nodes. (B) The addresses of Alzheimer Disease and its ancestor nodes. The nodes with bold black font represent the common nodes of the two DAGs.
<img src="https://github.com/Sunmile/IMPMD/blob/master/Figures/Figure_5.png"> 







# Notebook

## 2018-04-23

I got everything to Lauren. See scripts from scr/2018-04-23/. They are responsible for:
1) generating a QA table
2) generating a table of scored kegg cpds

I need to finish algorithm to check each compound for retention time matches within scoring system. Find current code in progress within:
scr/2018-04-23/checkingPathways.R

Also - get Lauren a table of how much each correction is changing features for each sample. Should have columns of 

1) post processing
2) Blank correction
3) adduct correction
4) Final Count

## 2018-04-20

Sent the density and venn diagram off to Lauren. Next I need to check the pathways she recommended to suggest possible metabolites to check for retention time. See email for more.

## 2018-04-19

TO DO: Look at the kegg table for the metabolisms Lauren specifies.

Created Venn Diagram for the data. Now I only need to make the density plots to show that the differences in features are not due to adducts/chemical impurities... ect. 

## 2018-04-18

Issues: I found that proteowizard processed the data within SRM parameter. It's unclear how this will affect the processing. Feature table generated through kegg mapping should be similar since those are technically features within the data. I need to figure out how to get the MS2s to get more out of it. 

See package:MRMconverteR - I may need to get this to work since I am using a different version of msconvert to make my data. 

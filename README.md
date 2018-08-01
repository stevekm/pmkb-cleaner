# Precision Medicine Knowledgebase Cleaner

This scripted workflow will download an Excel formatted list of all clinical variant interpretations offered by the Precision Medicine Knowledgebase, convert the file to .tsv format, and output lists of all Tumor and Tissue terms used, among other things. 

https://pmkb.weill.cornell.edu/

> The Precision Medicine Knowledgebase (PMKB) is a project of the Institute of Precision Medicine (IPM) at Weill Cornell Medicine.
> PMKB is organized to provide information about clinical cancer variants and interpretations in a structured way, as well as allowing users to submit and edit existing entries for continued growth of the knowledgebase. All changes are reviewed by cancer pathologists. 

## Data

Copies of the files used and produced in this workflow are saved in the included `data` directory. Note that these may not reflect future changes to the PMKB.

# Software

- GNU `make`

- `bash` shell

- Python 3+ (conda automatic setup included in Makefile)

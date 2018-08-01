# Makefile for downloading and cleaning up the Excel formatted 
# clinical interpretations from Weill Cornell Precision Medicine Knowledge Base
PYTHONVERSION:=venv-py2.7
URL:=https://pmkb.weill.cornell.edu/therapies/download.xlsx
BASENAME:=pmkb
XLSX:=$(BASENAME).xlsx
TSV:=$(BASENAME).Interpretations.tsv

all: download conda dump tumor tissue

# ~~~~~ download the PMKB database file ~~~~~ #
$(XLSX):
	@echo ">>> Downloading clinical interpretations sheet from PMKB"
	wget "$(URL)" -O "$(XLSX)"
download: $(XLSX)


# ~~~~~ Setup Conda Python 3 needed to manipulate UTF-16 xlsx ~~~~~ #
CONDASH:=Miniconda3-4.5.4-Linux-x86_64.sh
CONDAURL:=https://repo.continuum.io/miniconda/$(CONDASH)
conda:
	wget "$(CONDAURL)" && \
	bash "$(CONDASH)" -b -p conda && \
	rm -f "$(CONDASH)" 
conda-install: conda
	unset PYTHONHOME && \
	unset PYTHONPATH && \
	export PATH=$${PWD}/conda/bin:$${PATH} && \
	conda install -y pandas 'xlrd>=0.9.0'


# ~~~~~ dump the .xlsx file to .tsv ~~~~~ #
$(TSV): $(XLSX) conda
	@echo ">>> Dumping .xlsx to .tsv"
	unset PYTHONHOME && \
	unset PYTHONPATH && \
	export PATH=$${PWD}/conda/bin:$${PATH} && \
	python dump-xlsx.py "$(XLSX)"
dump: $(TSV)

# ~~~~~ get the Tumor and Tissue terms from the sheet ~~~~~ #
TUMORFILE:=$(BASENAME)-tumor-terms.txt
TISSUEFILE:=$(BASENAME)-tissue-terms.txt

$(TUMORFILE): $(TSV)
	unset PYTHONHOME && \
	unset PYTHONPATH && \
	export PATH=$${PWD}/conda/bin:$${PATH} && \
	python cut.py "$(TSV)" -f 2 -e "utf-16" | tr ',' '\n'| sed -e 's|^[[:space:]]||g' -e 's|[[:space:]]$$||g' -e 's|^$$||g' | sort -u > "$(TUMORFILE)"
tumor: $(TUMORFILE)

$(TISSUEFILE): $(TSV)
	unset PYTHONHOME && \
	unset PYTHONPATH && \
	export PATH=$${PWD}/conda/bin:$${PATH} && \
	python cut.py "$(TSV)" -f 3 -e "utf-16" | tr ',' '\n' | sed -e 's|^[[:space:]]||g' -e 's|[[:space:]]$$||g' -e 's|^$$||g' | sort -u > "$(TISSUEFILE)"
tissue: $(TISSUEFILE)

clean:
	rm -f "$(XLSX)" "$(TSV)" "$(TISSUEFILE)" "$(TUMORFILE)"

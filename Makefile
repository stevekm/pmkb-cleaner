# Makefile for downloading and cleaning up the Excel formatted 
# clinical interpretations from Weill Cornell Precision Medicine Knowledge Base
PYTHONVERSION:=venv-py2.7
URL:=https://pmkb.weill.cornell.edu/therapies/download.xlsx
BASENAME:=pmkb
XLSX:=$(BASENAME).xlsx
TSV:=$(BASENAME).Interpretations.tsv

all: download venv dump tumor tissue

# ~~~~~ download the PMKB database file ~~~~~ #
$(XLSX):
	@echo ">>> Downloading clinical interpretations sheet from PMKB"
	wget "$(URL)" -O "$(XLSX)"
download: $(XLSX)


# ~~~~~ Create Python 2.7 Virtual Environment and install pandas ~~~~~ #
venv/bin/activate:
	@echo ">>> Creating new virtual environment"
	unset PYTHONPATH && \
	virtualenv venv --no-site-packages

# install the dependencies
setup-venv: venv/bin/activate
	@echo ">>> Installing requirements to the virtualenv"
	unset PYTHONPATH && \
	source venv/bin/activate && \
	pip install -r requirements.txt
venv-py2.7: setup-venv
venv: $(PYTHONVERSION)
.PHONY: venv


# ~~~~~ dump the .xlsx file to .tsv ~~~~~ #
$(TSV): $(XLSX) venv/bin/activate
	@echo ">>> Dumping .xlsx to .tsv"
	unset PYTHONPATH && \
	source venv/bin/activate && \
	python dump-xlsx.py "$(XLSX)"
dump: $(TSV)

# ~~~~~ get the Tumor and Tissue terms from the sheet ~~~~~ #
TUMORFILE:=tumor-terms.txt
TISSUEFILE:=tissue-terms.txt

$(TUMORFILE): $(TSV)
	python cut.py "$(TSV)" -f 2 | tr ',' '\n'| sed -e 's|^[[:space:]]||g' -e 's|[[:space:]]$$||g' -e 's|^$$||g' | sort -u > "$(TUMORFILE)"
tumor: $(TUMORFILE)

$(TISSUEFILE): $(TSV)
	python cut.py "$(TSV)" -f 3 | tr ',' '\n' | sed -e 's|^[[:space:]]||g' -e 's|[[:space:]]$$||g' -e 's|^$$||g' | sort -u > "$(TISSUEFILE)"
tissue: $(TISSUEFILE)

clean:
	rm -f "$(XLSX)" "$(TSV)" "$(TISSUEFILE)" "$(TUMORFILE)"

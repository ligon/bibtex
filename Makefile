LIGON=ligon_published.bib selected_working_papers.bib

DONOTEDIT="% This file automatically generated $(shell date) (see Makefile); do not edit!"

ligon.bib: $(LIGON)
	echo $(DONOTEDIT) > ligon.bib
	bibtool $(LIGON) >> ligon.bib

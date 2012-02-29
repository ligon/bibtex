ALL=$(shell ls *.bib)

LIGON=ligon_published.bib selected_working_papers.bib

DONOTEDIT="% This file automatically generated $(shell date) (see Makefile); do not edit! \
           Instead edit ligon_published.bib and selected_working_papers.bib."

all: ligon.bib papers.html main.bib

ligon.bib: $(LIGON)
	echo $(DONOTEDIT) > ligon.bib
	bibtool $(LIGON) >> ligon.bib

main.bib: $(ALL)
	echo $(ALL)

papers.html: ligon.bib
	bibtex2html -d -r -nobibsource -o papers ligon.bib

install: papers.html
	scp papers.html nature.berkeley.edu:public_html/

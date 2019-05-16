ALL=$(shell ls *.bib)

LIGON=ligon_published.bib selected_working_papers.bib

DONOTEDIT="% This file automatically generated $(shell date) (see Makefile); do not edit! \
           Instead edit ligon_published.bib and selected_working_papers.bib."

all: ligon.bib papers.html selected_working_papers.html ligon_published.html 

ligon.bib: $(LIGON)
	echo $(DONOTEDIT) > ligon.bib
	bibtool $(LIGON) >> ligon.bib

main.bib: $(ALL)
	echo $(ALL)

papers.html: ligon.bib
	bibtex2html -d -r -nokeys -o papers ligon.bib

selected_working_papers.html: selected_working_papers.bib
	bibtex2html -d -r -nokeys -o selected_working_papers selected_working_papers.bib

ligon_published.html: ligon_published.bib
	bibtex2html -d -r -nokeys -o ligon_published ligon_published.bib

install: papers.html ligon_published.html selected_working_papers.html ligon.bib
	scp papers.html selected_working_papers.html ligon_published.html \
            papers_bib.html selected_working_papers_bib.html ligon_published_bib.html \
            ligon@nature.berkeley.edu:public_html/

ALL=$(shell ls *.bib)

LIGON=published_code_and_data.bib ligon_published.bib selected_working_papers.bib other_working_papers.bib

DONOTEDIT="% This file automatically generated $(shell date) (see Makefile); do not edit! \
           Instead edit ligon_published.bib and *_working_papers.bib."

all: ligon.bib papers.html selected_working_papers.html ligon_published.html published_code_and_data.html

ligon.bib: $(LIGON)
	echo $(DONOTEDIT) > ligon.bib
	bibtool $(LIGON) >> ligon.bib

all.bib:
	echo $(DONOTEDIT) > all.bib
	bibtool $(ALL)  >> all.bib

papers.html: ligon.bib
	bibtex2html -d -r -nokeys -o papers ligon.bib

selected_working_papers.html: selected_working_papers.bib
	bibtex2html -d -r -nokeys -o selected_working_papers selected_working_papers.bib

published_code_and_data.html: published_code_and_data.bib
	bibtex2html -d -r -nokeys -o published_code_and_data published_code_and_data.bib

ligon_published.html: ligon_published.bib
	bibtex2html -d -r -nokeys -o ligon_published ligon_published.bib

install: papers.html ligon_published.html selected_working_papers.html ligon.bib published_code_and_data.html
	scp papers.html selected_working_papers.html ligon_published.html \
            papers_bib.html selected_working_papers_bib.html ligon_published_bib.html \
            published_code_and_data.html ligon@nature.berkeley.edu:public_html/

# Keys must be all lowercase.  BibTeX keys are case-sensitive in biber
# and CSL, but a citation whose case does not match its entry fails
# *silently* -- CSL renders "NO ITEM" and the export still succeeds.
# Nine keys in ligon_published.bib carried mixed case while main.bib
# held lowercase forms of the same works, so lowercase citations
# resolved in some documents and vanished in others.  Caught 2026-07-27
# when nine publications, including ligon-etal02, were missing from the
# Step VI publications list.
check-keys:
	@bad=$$(grep -hoE '^@[A-Za-z]+\{[[:space:]]*[^,]+,' $(ALL) \
	        | sed -E 's/^@[A-Za-z]+\{[[:space:]]*//; s/,$$//' \
	        | grep -E '[A-Z]' || true); \
	if [ -n "$$bad" ]; then \
	  echo "check-keys: non-lowercase citation keys found:"; \
	  echo "$$bad" | sed 's/^/  /'; exit 1; \
	else echo "check-keys: all keys lowercase"; fi

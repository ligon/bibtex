LIGON=ligon_published.bib selected_working_papers.bib

ligon.bib: $(LIGON)
	bibtool $(LIGON) > ligon.bib

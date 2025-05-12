MONTH:=$(shell LC_TIME=nl_NL gdate -d '-30 days' +'%Y-%B')

SPLIT=$(subst -, ,$(MONTH))
TOYEAR=$(word 1, $(SPLIT))
TOMONTH=$(word 2, $(SPLIT))
UREN_TEX=$(MONTH)-uren.table.tex
FACTUUR_TEX=$(MONTH)-factuur.table.tex

.PRECIOUS: $(MONTH).tex
.DEFAULT_GOAL:=uren
.PHONY: clean uren factuur
.INTERMEDIATE: commands.tex texout/*


uren: $(MONTH)-uren.pdf

factuur: $(MONTH)-factuur.pdf


$(UREN_TEX):
	python src/uren.py $(TOYEAR) $(TOMONTH) > $@


$(FACTUUR_TEX):
	python src/factuur.py $(TOYEAR) $(TOMONTH) > $@

$(MONTH)-uren.pdf:  uren.tex $(UREN_TEX) commands.tex
	mkdir -p texout
	lualatex -output-directory=texout  $<
	mv -f texout/uren.pdf $@

$(MONTH)-factuur.pdf:  factuur.tex $(MONTH)-uren.table.tex commands.tex
	mkdir -p texout
	lualatex -output-directory=texout  $<
	mv -f texout/factuur.pdf $@

commands.tex:
	printf '\\newcommand{\\aboutmonth}{$(TOMONTH) $(TOYEAR)}\n' > $@
	printf '\\newcommand{\\urentable}{\input{$(MONTH)-uren.table.tex}}' >> $@


clean:
	rm -rf texout $(MONTH)-uren.table.tex $(MONTH)-uren.pdf


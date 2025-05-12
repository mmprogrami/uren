MONTH:=$(shell LC_TIME=nl_NL gdate -d '-1 month' +'%Y-%B')

SPLIT=$(subst -, ,$(MONTH))
TOYEAR=$(word 1, $(SPLIT))
TOMONTH=$(word 2, $(SPLIT))
UREN_TEX=$(MONTH)-uren.table.tex
FACTUUR_TEX=$(MONTH)-factuur.table.tex

.PRECIOUS: $(MONTH).tex
.DEFAULT_GOAL:=uren
.PHONY: clean uren factuur
.INTERMEDIATE: commands.tex


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

$(MONTH)-factuur.pdf:  factuur.tex $(FACTUUR_TEX) commands.tex
	mkdir -p texout
	lualatex -output-directory=texout  $<
	mv -f texout/factuur.pdf $@

commands.tex:
	printf '\\newcommand{\\aboutmonth}{$(TOMONTH) $(TOYEAR)}\n' > $@
	printf '\\newcommand{\\urentable}{\input{$(UREN_TEX)}}' >> $@
	printf '\\newcommand{\\factuurtable}{\input{$(FACTUUR_TEX)}}' >> $@


clean:
	rm -rf texout $(MONTH)-uren.table.tex $(MONTH)-uren.pdf


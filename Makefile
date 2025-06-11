MONTH:=$(shell LC_TIME=nl_NL gdate -d '-1 month' +'%Y-%B')
CLIENT:=NPO

SPLIT=$(subst -, ,$(MONTH))
TOYEAR=$(word 1, $(SPLIT))
TOMONTH=$(word 2, $(SPLIT))
UREN_TEX=$(MONTH)-uren.table.tex
FACTUUR_TEX=$(MONTH)-factuur.table.tex

DRIVE=/Users/michiel/Library/CloudStorage/GoogleDrive-michiel.mmprogrami@gmail.com/My\ Drive/$(CLIENT)/

ORDERNUMBER=NP-30028502
export ORDERNUMBER
export TOYEAR
export TOMONTH

.PRECIOUS: $(MONTH).tex
.DEFAULT_GOAL:=uren
.PHONY: clean uren factuur
.INTERMEDIATE: commands.tex


uren: $(MONTH)-uren.pdf  ## make uren for previous month (or e.g. MONTH=2025-april) (and copy to DRIVE)
	cp -f $(MONTH)-uren.pdf $(DRIVE)/$(TOYEAR)

factuur: $(MONTH)-factuur.pdf   ## make factuur for previous month (or e.g. MONTH=2025-april) (and copy to DRIVE)
	cp -f $(MONTH)-factuur.pdf $(DRIVE)/$(TOYEAR)


$(UREN_TEX): src/uren.py src/base_uren.py
	python src/uren.py $(TOYEAR) $(TOMONTH) > $@


$(FACTUUR_TEX):
	python src/factuur.py $(TOYEAR) $(TOMONTH) > $@

$(MONTH)-uren.pdf:  uren.tex $(UREN_TEX) commands.tex Makefile mmprogrami.sty
	mkdir -p texout
	lualatex -output-directory=texout  $<
	lualatex -output-directory=texout  $<
	mv -f texout/uren.pdf $@

$(MONTH)-factuur.pdf:  factuur.tex $(FACTUUR_TEX) commands.tex Makefile mmprogrami.sty
	mkdir -p texout
	lualatex -output-directory=texout  $<
	mv -f texout/factuur.pdf $@

commands.tex: Makefile
	printf '%%automatically created file (see Makefile)\n' > $@
	printf '\\newcommand{\\aboutmonth}{$(TOMONTH) $(TOYEAR)}\n' >> $@
	printf '\\newcommand{\\urentable}{\input{$(UREN_TEX)}}\n' >> $@
	printf '\\newcommand{\\factuurtable}{\input{$(FACTUUR_TEX)}}\n' >> $@


clean:
	rm -rf texout $(MONTH)-uren.table.tex $(MONTH)-uren.pdf

help:     ## Show this help.
	@echo "Find relevant sheet at https://docs.google.com/spreadsheets/d/1_c9zqs-9-ke2ez2E8bfhVRl1q0crhuKxrao2XrYrtp8/edit?gid=1711645104#gid=1711645104"
	@echo "Current drive: $(DRIVE)"
	@sed -n 's/^##//p' $(MAKEFILE_LIST)
	@grep -E '^[/%a-zA-Z._-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo "$$HELP"

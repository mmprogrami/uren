MONTH:=2025-april

SPLIT=$(subst -, ,$(MONTH))
TOYEAR=$(word 1, $(SPLIT))
TOMONTH=$(word 2, $(SPLIT))

.PRECIOUS: $(MONTH).tex
.DEFAULT_GOAL:=$(MONTH)-uren.pdf
.PHONY: clean
.INTERMEDIATE: table.tex commands.tex texout/*


$(MONTH).tex:
	python src/uren.py $(TOYEAR) $(TOMONTH) > $(MONTH).tex

$(MONTH)-uren.pdf:  uren.tex $(MONTH).tex table.tex commands.tex
	mkdir -p texout
	lualatex -output-directory=texout  $<
	mv -f texout/uren.pdf $@

commands.tex:
	printf '\\newcommand{\\aboutmonth}{$(TOMONTH) $(TOYEAR)}' > $@


table.tex:
	ln -sf $(MONTH).tex table.tex

clean:
	rm -rf texout $(MONTH).tex $(MONTH)-uren.pdf


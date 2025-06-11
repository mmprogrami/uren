#!/usr/bin/env python
import sys

from pylatex import Tabularx, NoEscape

from base_uren import BaseUren

class Uren(BaseUren):

	def generate_latex_table(self, uren:list):
		uren = uren.copy()
		uren.sort(key=lambda e: e.day)
		tabular = Tabularx("ccl")
		tabular.add_hline()
		tabular.add_row([NoEscape("\\textbf{Datum}"), NoEscape("\\textbf{Opmerkingen}"), NoEscape("\\textbf{Aantal uur}")])
		tabular.add_hline()
		sum = 0
		for entry in uren:
			sum += entry.value
			tabular.add_row([entry.day, entry.issue, "{:0.1f}".format(entry.value) ])
		tabular.add_hline()
		tabular.add_row(["", "", "{:0.1f}".format(sum) ])
		tabular.dump(sys.stdout)


Uren().report(sys.argv[1], sys.argv[2])

#!/usr/bin/env python
import sys

from pylatex import Tabular

from base_uren import BaseUren


class Factuur(BaseUren):


    def generate_latex_table(self, sheet):
        data = sheet.get_all_values()

        # Determine the column format
        num_cols = len(data[0]) if data else 0
        col_format = '|' + 'c|' * num_cols

        # Create tabular environment
        tabular = Tabular(col_format)

        tabular.add_hline()

        # Add header row
        header_row = data[0]
        tabular.add_row(header_row)
        tabular.add_hline()

        # Add data rows
        for row in data[1:]:
            tabular.add_row(row)

        tabular.add_hline()

        tabular.dump(sys.stdout)



Factuur().report(sys.argv[1], sys.argv[2])

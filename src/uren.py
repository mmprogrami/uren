#!/usr/bin/env python
import logging
import sys

import gspread

from pylatex import Document, Table, Tabular

class Uren:

    def __init__(self ):
        logging.basicConfig(stream=sys.stderr, level=logging.INFO)

        # See
        self.gc = gspread.service_account()

        # Open a sheet from a spreadsheet in one go
        self.spreadsheet = self.gc.open("Uren")

    def report(self, year, month):
        for sheet in self.spreadsheet.worksheets():
            logging.info("spread %s", sheet.title)
            if sheet.title == "%s %s" % (year, month):
                self.generate_latex_table(sheet)

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



Uren().report(sys.argv[1], sys.argv[2])

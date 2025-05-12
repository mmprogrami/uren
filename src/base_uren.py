#!/usr/bin/env python
import logging
import sys

import gspread
from abc import  abstractmethod


class BaseUren:

    def __init__(self ):
        logging.basicConfig(stream=sys.stderr, level=logging.INFO)

        # See
        self.gc = gspread.service_account()

        # Open a sheet from a spreadsheet in one go
        self.spreadsheet = self.gc.open("Uren")

    def report(self, year, month):
        for sheet in self.spreadsheet.worksheets():
            logging.debug("spread %s", sheet.title)
            if sheet.title == "%s %s" % (year, month):
                logging.info("Generating spread %s", sheet.title)
                self.generate_latex_table(sheet)

    @abstractmethod
    def generate_latex_table(self, sheet):
      pass


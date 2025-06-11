#!/usr/bin/env python
import logging
import sys

import gspread
from abc import  abstractmethod
from array import array


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
				logging.info("Reading spread %s", sheet.title)
				data = sheet.get_all_values()
				# Add data rows
				uren = []
				reading = False
				dates = {}
				for row in data[1:]:
					project = row[0]
					if project == 'dagen':
						for i in range(2, len(row)):
							dates[i] = year + "-" + row[i]
						reading = True
					if project == 'NPO' and reading:
						for i in range(2, len(row)):
							try:
								v = float(row[i])
								uren.append(UrenEntry(dates[i], row[1], v))
							except:
								pass
				self.generate_latex_table(uren)

	@abstractmethod
	def generate_latex_table(self, uren: list):
		pass

class UrenEntry:
	def __init__(self, day:str, issue:str, value:float):
		self.day = day
		self.issue = issue
		self.value = value



#!/usr/bin/env python
"""
Convert a table from wide format to long format based on the contents of a column
NOTE: Python 3+ required for utf-16 input !!
"""
import sys
import csv
import argparse

def main(**kwargs):
    """
    Main control function for the script
    """
    input_file = kwargs.pop('input_file')[0]
    delimiter = kwargs.pop('delimiter', '\t')
    output_file = kwargs.pop('output_file', '\t')
    split_char = kwargs.pop('split_char', ',')
    field_num = int(kwargs.pop('field_num', 1)) - 1 # field numbers are 1-based but Python list index is 0-based
    input_encoding = kwargs.pop('input_encoding', 'utf-8')
    output_encoding = kwargs.pop('output_encoding', 'utf-8')

    # input
    fin = open(input_file, encoding = input_encoding)
    reader = csv.DictReader(fin, delimiter = delimiter)
    fieldnames = reader.fieldnames
    field_to_split = fieldnames[field_num]

    # output
    # fout = sys.stdout # , encoding = output_encoding
    fout = open(output_file, "w", encoding = output_encoding)
    writer = csv.DictWriter(fout, delimiter = delimiter, fieldnames = fieldnames)
    writer.writeheader()

    for row in reader:
        # get a list of the values in the desired field
        split_values = [x.strip() for x in row[field_to_split].split(split_char)]
        for split_value in split_values:
            # make a list of rows to be
            new_rows = [ {k:v} for k, v in row.items()]
            for new_row in new_rows:
                # new_row[field_to_split] = split_value
                writer.writerow(new_row)


        # print(new_rows)

    fout.close()
    fin.close()

def parse():
    """
    Parses script args
    """
    parser = argparse.ArgumentParser(description='Prints a column from a file')
    parser.add_argument('input_file', nargs=1, help="Input file")
    parser.add_argument("-o", required = True, dest = 'output_file', help="Output file")
    parser.add_argument("-d", default = '\t', dest = 'delimiter', help="Table delimiter")
    parser.add_argument("-f", default = 1, dest = 'field_num', help="Column in the file to output")
    parser.add_argument("-s", "--split", default = ',', dest = 'split_char', help="Character to split field on")
    parser.add_argument("-e", "--input-encoding", default = 'utf-8', dest = 'input_encoding', help="Input file text encoding. NOTE: Python 3+ required for utf-16") # "utf-16"
    parser.add_argument("--output-encoding", default = 'utf-8', dest = 'output_encoding', help="Output file text encoding. NOTE: Python 3+ required for utf-16") # "utf-16"
    args = parser.parse_args()

    main(**vars(args))

if __name__ == '__main__':
    parse()

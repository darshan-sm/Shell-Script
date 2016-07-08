#!/data/1/opt/python/bin/python

from __future__ import division

def calculator(num1, num2):
    num1 = float(num1)
    num2 = float(num2)
    percentage = '{0:.2f}'.format((num1 / num2 * 100))
    print percentage
    return percentage

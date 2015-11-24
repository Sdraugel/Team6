#! /usr/bin/python 
#PROG Jeremy Butcheck
#PROJ Team6
#FROM 11/11/2015

import sys
import importlib
import fileinput
import functools
import os
import eden

sys.path.append(os.getcwd() + '/testCasesExecutables/eden/modules');
sys.path.append(os.getcwd() + '/testCasesExecutables/eden/static/scripts/tools');

module_name = os.getenv('class').strip(' ').replace(".py","").replace("/",".")
args = os.getenv('input').strip(' ').split(' ')
method_name = os.getenv('method').strip(' ')

mod = importlib.import_module('eden.{}'.format(module_name))

try:
    method = functools.partial(getattr(mod,'{}'.format(method_name)),*args)
    ret = method()
except TypeError as e:
    try:
        args = [int(arg) for arg in args ]
        method = functools.partial(getattr(mod,'{}'.format(method_name)),*args)
        ret = method()
    except Exception as e_2:
        print(e)
        print(e_2)

print ret

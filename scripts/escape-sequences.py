#!/bin/env python
# source https://stackoverflow.com/questions/46614602/how-to-capture-escape-sequences-sent-by-terminal

import curses
from pprint import pprint

buf = ''

def main(stdscr):
  global buf
  curses.noecho()
  curses.raw()
  curses.cbreak()
  stdscr.keypad(False)

  stop = stdscr.getkey()
  c = stdscr.getkey()
  buf = ''  
  while c != stop:
    buf += c
    c = stdscr.getkey()

def run():
  print("First press a letter, then any sequence of keys and then the same letter again to exit.")  
  curses.wrapper(main)
  pprint(buf)
  tmp = buf.encode('latin1')
  pprint([hex(x) for x in tmp])
  pprint([bin(x) for x in tmp])

run()
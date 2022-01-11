Algorithms
==========

This is a central place for a list of Lua modules for standard algorithms.

The focus of these modules is to be:

1. very well tested
2. very well documented
3. performant

In that order. This allows one to trust the code, instead of fighting dependencies or reimplementing (and worse; rewriting the tests) over and over again.


List of available modules:
--------------------------

## [linked-list](https://github.com/Tieske/linkedlist.lua)

- contains a linked list and a double-linked list

## [timerwheel](https://github.com/Tieske/timerwheel.lua)

- a timerwheel providing timers with very efficient set/cancel operations
- ideal for I/O operations where a high number of timers are scheduled and deleted as timeouts

## [binary-heap/binary-tree](https://github.com/Tieske/binaryheap.lua)

- an efficient sorting algorithm
- provides a plain heap/tree as well as one with reverse-lookups

## [many-to-one cache](https://github.com/Tieske/ncache.lua)

- normalization/canonicalization to compare for equality can be expensive. This cache
  helps doing that only once for each input and caches the output.


# linkedlist.lua

Linked-list implementation for Lua. Includes a linked-list as well as a
double-linked list.

This module is part of [a set of algorithms](https://github.com/Tieske/linkedlist.lua/blob/main/algorithms.md).


Installation
============

Install through LuaRocks (`luarocks install linkedlist`) or from source, see the
[github repo](https://github.com/Tieske/linkedlist.lua).

Documentation
=============

The docs are [available online](https://tieske.github.io/linkedlist.lua/), or can
be generated using [Ldoc](https://github.com/lunarmodules/LDoc). Just run
`"ldoc ."` from the repo.


Tests
=====

Tests are in the `spec` folder and can be executed using the
[busted test framework](http://olivine-labs.github.io/busted/). Just run
`"busted"` from the repo. This requires `LuaCov` to be installed.

Besides that `luacheck` is configured for linting, just run `"luacheck ."` from
the repo. The Busted test-run will result in a coverage report (file
`"luacov.report.out"`).


Copyright and License
=====================

See [LICENSE](https://github.com/Tieske/linkedlist.lua/blob/main/LICENSE).

History
=======


### 0.1.0 released xx-xxx-2022

  - Initial released version

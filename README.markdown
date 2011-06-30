Git Checker
===========

The raw_git_checker is a raw (rly?) version of the git_checker (not existing yet).

Screenshot: http://dl.dropbox.com/u/5847684/Screen%20shot%202011-06-30%20at%201.05.43%20PM.png

It consist in two ruby clases, a module (where I put my script, what I realy want to do) and the invoke of that scripts at the bottom.

It's like a Test for your git.

Install:
--------

1. Modify the module Checker for cover your needs.
2. Execute the git_checker.rb in your git repository that you want to check. 	 

Pro-install:
------------

1. Open your .bash_profile file and add this line.
`alias check='ruby ~/git_checker.rb'`
2. Reload your terminal.
3. Execute the check command (alias) in your git repository that you wan to check.

Usage:
------

There is not specific "usage" since that you can make your own script, but basically: less output, more good.

Note:
-----

The merges with the branches have to be with the option --no-ff for better results (and it's a good practice). Basically --no-ff force git to create a commit always when you merge.

Example:
`git merge issue-111 --no-ff`

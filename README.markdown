Git Checker
===========

The raw_git_checker is a raw (rly?) version of the git_checker (not existing yet).

Screenshot: http://dl.dropbox.com/u/5847684/Screen%20shot%202011-06-30%20at%201.05.43%20PM.png

It consist in two ruby clases, a module (where I put my script, what I realy want to do) and the invoke of that scripts at the bottom.

Usage:

1. Modify the module Checker for cover your needs (or not, but you probably have the branch Master, and not Staging).
2. Execute the git_checker.rb in your git repository that you want to check. 	 

Pro-usage:

1. Open your .bash_profile file and add this line.
`alias check='ruby ~/git_checker.rb'`
2. Reload your terminal.
3. Execute the check command (alias) in your git repository that you wan to check.

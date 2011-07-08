#!/usr/bin/env ruby

require_relative 'message_printer'
require_relative 'repository'
require_relative 'branch'

class Checker
  
  include MessagePrinter
  
  IGNORE_BRANCHES = ["all", "*"]

  attr_accessor :local, :remote
  
  def initialize(path = nil)
    @local = Repository.new
    @remote = Repository.new 'origin'  
    @path = path || Dir.pwd
  end

  def local_branches_not_in_remote
    print_message "Locals not in Remote"
    puts @remote.missing_branches(@local.list_of_branches) - IGNORE_BRANCHES
  end

  def branches_not_merged_with_master
    branches = []
    branch = @local.branches["master"]
    @local.branches.each_value do |b|
      unless IGNORE_BRANCHES.include? b.name
        branches << b.name if branch.merges_with(b.name).empty?
      end
    end

    print_message "Branches not in Master"
    puts branches
  end

  def commits_not_merged_with_master
    print_message "Commits not in Master", :pound => '+'

    master = @local.branches["master"]
    @local.branches.each_value do |branch|
      unless IGNORE_BRANCHES.include? branch.name
        log = master.commits_not_merged_from branch
        unless log.empty?
          puts "\n\n\e[1m\e[31m\e[7m++++ #{branch.name}: Commits not on Master ++++\e[m\e[m\e[m"
          puts log
        end
      end
    end
  end

end

checker = Checker.new
checker.local_branches_not_in_remote
checker.branches_not_merged_with_master
checker.commits_not_merged_with_master

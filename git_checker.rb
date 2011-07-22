#!/usr/bin/env ruby

require_relative 'message_printer'
require_relative 'repository'
require_relative 'branch'

module GitChecker
  def compare_branches_between_repos target_repo, repo_to_compare, ignore=[]
    puts target_repo.missing_branches(repo_to_compare.list_of_branches) - ignore
  end

  def check_if_branches_are_merged_in target_branch, repo_to_check, ignore=[]
    branches = []
    repo_to_check.branches.values.each do |b|
      unless ignore.include? b.name
        branches << b.name if target_branch.merges_with(b.name).empty?
      end
    end
    puts branches
  end

  def check_what_commits_not_merged_with target_branch, repo_to_check, ignore=[]
    repo_to_check.branches.each_value do |b|
      unless ignore.include? b.name
        log = target_branch.commits_not_merged_from b
        unless log.empty?
          puts "\n\n\e[1m\e[31m\e[7m++++ #{b.name}: Commits not on Master ++++\e[m\e[m\e[m"
          puts log
        end
      end
    end
  end
end

class Checker

  include MessagePrinter
  include GitChecker

  IGNORE_BRANCHES = ["all", "*"]

  attr_accessor :local, :remote

  def initialize(path = nil)
    @local = Repository.new
    @remote = Repository.new 'origin'
    @path = path || Dir.pwd
  end

  def local_branches_not_in_remote
    print_message "Locals not in Remote"
    compare_branches_between_repos @remote, @local, IGNORE_BRANCHES
  end

  ## MASTER
  def branches_not_merged_with_master
    print_message "Branches not in Master"
    check_if_branches_are_merged_in @local.branches["master"], @local, IGNORE_BRANCHES
  end

  def commits_not_merged_with_master
    print_message "Commits not in Master", :pound => '+'
    check_what_commits_not_merged_with @local.branches["master"], @local, IGNORE_BRANCHES
  end

  ## STAGING
  def branches_not_merged_with_staging
    print_message "Branches not in Staging"
    check_if_branches_are_merged_in @local.branches["staging"], @local, IGNORE_BRANCHES
  end

  def commits_not_merged_with_staging
    print_message "Commits not in Staging", :pound => '+'
    check_what_commits_not_merged_with @local.branches["staging"], @local, IGNORE_BRANCHES
  end
end

checker = Checker.new
checker.local_branches_not_in_remote
#checker.branches_not_merged_with_master
#checker.commits_not_merged_with_master
checker.branches_not_merged_with_staging
checker.commits_not_merged_with_staging

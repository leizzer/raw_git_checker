#!/usr/bin/env ruby

class Repository
  attr_accessor :branches

  def initialize(repo = nil)
    collect_branches_from repo
  end

  def missing_branches branch_list
    branch_list.find_all {|b| !list_of_branches.include? b }
  end

  def list_of_branches
    @branches.keys
  end

  private

  def collect_branches_from repo
    @branches = {}
    list_branches(repo).each do |b|
      @branches[b] = Branch.new b, repo
    end
  end

  def list_branches repo
    if repo
      branch_name `git branch -r`.split, repo
    else
      `git branch`.split
    end
  end

  def branch_name list, repo
    list.map { |b| b.sub "#{repo}/", '' }
  end
end

class Branch
  attr_accessor :name, :repo

  def initialize name, repo=nil
    @name = name
    @repo = repo
  end

  def merges_with word
    log_merges.split.find_all { |mer| mer.include? word }
  end

  def log_merges
    `git log #{with_repo @repo}#{@name} --merges`
  end

  def commits_not_merged_from branch
    `git log --color #{with_repo @repo}#{@name}..#{with_repo branch.repo}#{branch.name}`
  end

  private
  def with_repo repo
    if repo
      "{repo}/"
    end
  end
end


module Checker

  @local = Repository.new
  @remote = Repository.new 'origin'

  IGNORE_BRANCHES = ["all", "*"]

  def local_branches_not_in_remote
    puts "\n\n\e[1m\e[36m\e[7m############# Locals not in Remote ############\e[m\e[m\e[m"
    puts @remote.missing_branches(@local.list_of_branches) - IGNORE_BRANCHES
  end

  def branches_not_merged_with_staging
    branches = []
    branch = @local.branches["staging"]
    @local.branches.each_value do |b|
      unless IGNORE_BRANCHES.include? b.name
        branches << b.name if branch.merges_with(b.name).empty?
      end
    end

    puts "\n\n\e[1m\e[36m\e[7m########### Branches not in Staging ###########\e[m\e[m\e[m"
    puts branches
  end

  def commits_not_merged_with_staging
    puts "\n\n\e[1m\e[36m\e[7m############ Commits not in Staging ###########\e[m\e[m\e[m"

    staging = @local.branches["staging"]
    @local.branches.each_value do |branch|
      unless IGNORE_BRANCHES.include? branch.name
        log = staging.commits_not_merged_from branch
        unless log.empty?
          puts "\n\n\e[1m\e[31m\e[7m++++ #{branch.name}: Commits not on Staging ++++\e[m\e[m\e[m"
          puts log
        end
      end
    end
  end

end

include Checker
Checker::local_branches_not_in_remote
Checker::branches_not_merged_with_staging
Checker::commits_not_merged_with_staging

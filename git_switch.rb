require_relative 'lib/handle_branch.rb'

class GitSwitch < Struct.new(:branch)

  def self.call(*args)
    new(*args).call
  end

  def initialize(branch)
    self.branch = branch
  end

  def call
    url? ? handle_pull_request_url : handle_branch(branch)
  end

  private

    def url?
      branch.match /https:\/\/github.com\//
    end

    def handle_pull_request_url
      fork? ? pull_branch_with_fork_prefix : handle_source_branch
    end

    def fork?
      !(user_name(branch) == user_name(origin_url))
    end

    def pull_branch_with_fork_prefix
      return true if system("hub checkout #{branch}")
    end

    def pull_branch
      true
    end

    def user_name(url)
      url.scan(/([\w\-_]+\/\w+).git/).flatten.first.split("/").first
    end

    def origin_url
      `git config --get remote.origin.url`
    end

    def handle_source_branch
      pull_branch_with_fork_prefix &&
      handle_branch(pull_branch)   &&
      delete_branch_with_fork_prefix
    end

    def handle_branch(branch)
      HandleBranch.(branch)
    end
end

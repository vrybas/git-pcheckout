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
      puts "handling Pull Request URL..."
      branch.match /https:\/\/github.com\//
    end

    def handle_pull_request_url
      fork? ? pull_branch_with_fork_prefix : handle_source_branch
    end

    def fork?
    user_name_from_branch = user_name_from_pull_request(branch)
    user_name_from_origin_url = user_name_from_origin(origin_url)
    user_name_from_branch != user_name_from_origin_url
    end

    def pull_branch_with_fork_prefix
      puts "fork detected. Pulling branch from fork..."
      out = `hub checkout #{branch}`
      return false if out == ''
      branch_name_with_fork_prefix = out.scan(/Branch (.+) set/).flatten.first
    end

    def substitute_fork_prefix(branch_name)
      branch_name.gsub("#{user_name_from_pull_request(branch)}-",'')
    end

    def user_name_from_origin(url)
      url.scan(/([\w\-_]+\/[\w\-_]+).git/).flatten.first.split("/").first
    end

    def user_name_from_pull_request(url)
    url.scan(/https:\/\/github.com\/([\w\-_]+\/[\w\-_]+)/).flatten.first.split("/").first
    end

    def origin_url
      `git config --get remote.origin.url`
    end

    def handle_source_branch
      puts "source repository branch detected. Pulling from origin..."
      if branch_name = pull_branch_with_fork_prefix
        handle_branch(substitute_fork_prefix(branch_name)) &&
        delete_branch(branch_name)
      end
    end

    def delete_branch(branch_name)
      system("git branch -D #{branch_name}")
    end

    def handle_branch(branch)
      HandleBranch.(branch)
    end
end

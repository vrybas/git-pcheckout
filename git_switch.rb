require_relative 'lib/handle_branch.rb'

class GitSwitch < Struct.new(:arg)

  def self.call(*args)
    new(*args).call
  end

  def initialize(arg)
    self.arg = arg
  end

  def call
    if pull_request_url?(arg)
      handle_pull_request_url(arg)
    else
      handle_branch_name(arg)
    end
  end

  private

    def pull_request_url?(arg)
      arg.match /https:\/\/github.com\//
    end

    def handle_pull_request_url(url)
      puts "handling Pull Request URL..."

      branch_name_with_prefix = checkout_pull_request_branch(url)

      if source_repository_branch?(branch_name_with_prefix)
        handle_source_branch(branch_name_with_prefix)
      end
    end

    def checkout_pull_request_branch(url)
      out = `hub checkout #{url}`
      return false if out == ''
      out.scan(/Branch (.+) set/).flatten.first
    end

    def source_repository_branch?(branch_name)
      branch_name.start_with?("#{user_name_from_origin(origin_url)}-")
    end

    def substitute_prefix(branch_name)
      branch_name.gsub("#{user_name_from_origin(origin_url)}-",'')
    end

    def user_name_from_origin(url)
      url.scan(/([\w\-_]+\/[\w\-_]+).git/).flatten.first.split("/").first
    end

    def origin_url
      `git config --get remote.origin.url`
    end

    def handle_source_branch(branch_name_with_prefix)
      handle_branch_name(substitute_prefix(branch_name_with_prefix)) &&
      delete_branch(branch_name_with_prefix)
    end

    def delete_branch(branch_name)
      system("git branch -D #{branch_name}")
    end

    def handle_branch_name(branch)
      HandleBranch.(branch)
    end
end

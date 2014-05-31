require 'git-pcheckout/handle_branch'

class GitPcheckout < Struct.new(:arg)
  def initialize(arg)
    self.arg = arg
  end

  def perform
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
      branch_name_with_prefix = checkout_pull_request_branch(url)

      if source_repository_branch?(branch_name_with_prefix)
        handle_source_branch(branch_name_with_prefix)
      end
    end

    def checkout_pull_request_branch(url)
      puts "handling Pull Request URL..."
      out = `hub checkout #{url}`
      return false if out == ''
      out.scan(/Branch (.+) set/).flatten.first
    end

    def source_repository_branch?(branch_name)
      branch_name.start_with?("#{origin_user_name}-")
    end

    def substitute_prefix(branch_name)
      branch_name.gsub("#{origin_user_name}-",'')
    end

    def origin_user_name
      origin_url.scan(/([\w\-_]+)\/[\w\-_]+.git/).flatten[0]
    end

    def origin_url
      `git config --get remote.origin.url`
    end

    def handle_source_branch(branch_name_with_prefix)
      branch_name = substitute_prefix(branch_name_with_prefix)
      handle_branch_name(branch_name)
      delete_branch(branch_name_with_prefix)
    end

    def delete_branch(branch_name)
      system("git branch -D #{branch_name}")
    end

    def handle_branch_name(branch)
      HandleBranch.new(branch).perform
    end
end

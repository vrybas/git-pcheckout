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
      puts "handling Pull Request URL..."

      branch_name_with_prefix = get_pull_request_branch

      if source_repository_branch?(branch_name_with_prefix)
        handle_source_branch(branch_name_with_prefix)
      end
    end

    def get_pull_request_branch
      out = `hub checkout #{branch}`
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

    def user_name_from_pull_request(url)
    url.scan(/https:\/\/github.com\/([\w\-_]+\/[\w\-_]+)/).flatten.first.split("/").first
    end

    def origin_url
      `git config --get remote.origin.url`
    end

    def handle_source_branch(branch_name_with_prefix)
      handle_branch(substitute_prefix(branch_name_with_prefix)) &&
      delete_branch(branch_name_with_prefix)
    end

    def delete_branch(branch_name)
      system("git branch -D #{branch_name}")
    end

    def handle_branch(branch)
      HandleBranch.(branch)
    end
end

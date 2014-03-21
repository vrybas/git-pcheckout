class GitSwitch < Struct.new(:branch)

  def self.call(*args)
    new(*args).call
  end

  def initialize(branch)
    self.branch = branch
  end

  def call
    url? ? handle_pull_request_url : handle_branch_name
  end

  private

    def url?
      branch.match /https:\/\/github.com\//
    end

    def handle_pull_request_url
    end

    def handle_branch_name
      if branch_exists_locally?
        checkout_local_branch && pull_from_origin
      else
        fetch_from_origin && checkout_and_track_branch
      end
    end

    def branch_exists_locally?
      return true unless `git show-ref refs/heads/#{branch}`.empty?
    end

    def checkout_local_branch
      system "git checkout #{branch}"
    end

    def pull_from_origin
      system "git pull origin #{branch}"
    end

    def fetch_from_origin
      system "git fetch origin"
    end

    def checkout_and_track_branch
      system "git checkout --track origin/#{branch}"
    end
end

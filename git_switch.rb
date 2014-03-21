class GitSwitch < Struct.new(:branch)

  def self.call(*args)
    new(*args).call
  end

  def initialize(branch)
    self.branch = branch
  end

  def call
    if branch_exists_locally?
      checkout_local_branch && pull_from_origin
    else
      fetch_from_origin && checkout_and_track_branch
    end
  end

  private

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

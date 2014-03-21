require_relative '../git_switch.rb'

describe GitSwitch do

  context ".call" do
    it "should delegate to #new() with all params" do
      expect_any_instance_of(GitSwitch).to receive("call").and_return(true)
      instance = GitSwitch.("foo")
      expect(instance).to be
    end

    it "should send #call() to created instance" do
      expect_any_instance_of(GitSwitch).to receive("call")
      GitSwitch.("foo")
    end
  end

  context "#initialize" do
    it "should set @branch" do
      instance = GitSwitch.new("foo")
      expect(instance.branch).to eql("foo")
    end
  end

  context "#call" do
    context "plain branch name" do
      it "should handle plain branch name" do
        expect_any_instance_of(GitSwitch).to receive("url?").and_return(false)
        expect_any_instance_of(GitSwitch).to receive("handle_branch_name").and_return(true)
        GitSwitch.("foo")
      end

      it "should checkout and pull if branch exists" do
        expect_any_instance_of(GitSwitch).to receive("url?").and_return(false)
        expect_any_instance_of(GitSwitch).to receive("branch_exists_locally?").and_return(true)
        expect_any_instance_of(GitSwitch).to receive("checkout_local_branch").and_return(true)
        expect_any_instance_of(GitSwitch).to receive("pull_from_origin").and_return(true)
        GitSwitch.("foo")
      end

      it "should fetch and checkout with track if branch not exist" do
        expect_any_instance_of(GitSwitch).to receive("url?").and_return(false)
        expect_any_instance_of(GitSwitch).to receive("branch_exists_locally?").and_return(false)
        expect_any_instance_of(GitSwitch).to receive("fetch_from_origin").and_return(true)
        expect_any_instance_of(GitSwitch).to receive("checkout_and_track_branch").and_return(true)
        GitSwitch.("foo")
      end
    end

    context "pull request url" do
      it "should handle pull_request_url" do
        expect_any_instance_of(GitSwitch).to receive("handle_pull_request_url").and_return(true)
        GitSwitch.("https://github.com/user/repo.git")
      end

      context "fork" do
        xit "should create a fork branch with prefix" do
          expect_any_instance_of(GitSwitch).to receive("url?").and_return(true)
          GitSwitch.("https://github.com/user/repo.git")
        end
      end

      context "source repository" do
        it "should create a fork branch with prefix"
        it "should checkout and pull if branch exists"
        it "should fetch and checkout with track if branch not exist"
      end
    end

  end
end

require_relative '../git_switch.rb'
require_relative '../lib/handle_branch.rb'

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
        expect_any_instance_of(HandleBranch).to receive("call").and_return(true)
        GitSwitch.("foo")
      end
    end

    context "pull request url" do
      it "should handle pull_request_url" do
        expect_any_instance_of(GitSwitch).to receive("handle_pull_request_url").and_return(true)
        GitSwitch.("https://github.com/user/repo.git")
      end

      context "fork" do
        it "should pull a fork branch with prefix" do
          origin_url = "https://github.com/forked_user/repo.git"
          expect_any_instance_of(GitSwitch).to receive("origin_url").and_return(origin_url)
          expect_any_instance_of(GitSwitch).to receive("pull_branch_with_fork_prefix").and_return(true)
          GitSwitch.("https://github.com/user/repo.git")
        end
      end

      context "source repository" do
        it "should handle a source branch, specified in pull request" do
          origin_url = "https://github.com/user/repo.git"
          expect_any_instance_of(GitSwitch).to receive("origin_url").and_return(origin_url)
          expect_any_instance_of(GitSwitch).to receive("pull_branch_with_fork_prefix").and_return(true)
          expect_any_instance_of(HandleBranch).to receive("call").and_return(true)
          expect_any_instance_of(GitSwitch).to receive("delete_branch_with_fork_prefix").and_return(true)
          GitSwitch.("https://github.com/user/repo.git")
        end
      end
    end

  end
end

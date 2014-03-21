require_relative '../git_switch.rb'

describe GitSwitch do

  context ".call" do
    it "should delegate to #new() with all params" do
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
      instance = GitSwitch.("foo")
      expect(instance.branch).to eql("foo")
    end
  end

  context "#call" do
    context "plain branch name" do
      it "should checkout and pull if branch exists"
      it "should fetch and checkout with track if branch not exist"
    end

    context "pull request url" do
      context "fork" do
        it "should create a fork branch with prefix"
      end

      context "source repository" do
        it "should create a fork branch with prefix"
        it "should checkout and pull if branch exists"
        it "should fetch and checkout with track if branch not exist"
      end
    end

  end
end

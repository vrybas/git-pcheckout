require_relative '../../lib/handle_branch.rb'

describe HandleBranch do

  context ".call" do
    it "should delegate to #new() with all params" do
      expect_any_instance_of(HandleBranch).to receive("call").and_return(true)
      instance = HandleBranch.("foo")
      expect(instance).to be
    end

    it "should send #call() to created instance" do
      expect_any_instance_of(HandleBranch).to receive("call")
      HandleBranch.("foo")
    end
  end

  context "#initialize" do
    it "should set @branch" do
      instance = HandleBranch.new("foo")
      expect(instance.branch).to eql("foo")
    end
  end

  context "#call" do
      it "should checkout and pull if branch exists" do
        expect_any_instance_of(HandleBranch).to receive("branch_exists_locally?").and_return(true)
        expect_any_instance_of(HandleBranch).to receive("checkout_local_branch").and_return(true)
        expect_any_instance_of(HandleBranch).to receive("pull_from_origin").and_return(true)
        HandleBranch.("foo")
      end

      it "should fetch and checkout with track if branch not exist" do
        expect_any_instance_of(HandleBranch).to receive("branch_exists_locally?").and_return(false)
        expect_any_instance_of(HandleBranch).to receive("fetch_from_origin").and_return(true)
        expect_any_instance_of(HandleBranch).to receive("checkout_and_track_branch").and_return(true)
        HandleBranch.("foo")
      end
  end
end

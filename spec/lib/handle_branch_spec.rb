require 'spec_helper'

describe HandleBranch do
  let(:handle_branch) { described_class.new('foo') }

  context '#perform' do
    it 'checkouts and pulls if branch exists' do
      handle_branch.stub('branch_exists_locally?').and_return(true)

      expect(handle_branch).to receive('checkout_local_branch').and_return(true)
      expect(handle_branch).to receive('pull_from_origin').and_return(true)

      handle_branch.perform
    end

   it 'fetches and checkouts with track if branch not exist' do
     handle_branch.stub('branch_exists_locally?').and_return(false)

     expect(handle_branch).to receive('fetch_from_origin').and_return(true)
     expect(handle_branch).to receive('checkout_and_track_branch').and_return(true)

     handle_branch.perform
   end
  end
end

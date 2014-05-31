require 'spec_helper'

describe GitPcheckout::Base do
  before do
    allow_any_instance_of(described_class).to receive(:system).and_return(true)

    handle_branch = double(:handle_branch, perform: 'handle_branch')
    HandleBranch.stub(:new).and_return(handle_branch)
  end

  context '#perofrm' do
    it 'doesn\'t run if current branch is dirty' do
      instance = described_class.new('foo')
      instance.stub(:dirty_branch?).and_return(true)
      expect { instance.perform }.to raise_error(SystemExit)
    end

    context 'plain branch name' do
      it 'handles plain branch name' do
        instance = described_class.new('foo')
        instance.stub(:dirty_branch?).and_return(false)

        expect(instance.perform).to eql('handle_branch')
      end
    end

    context 'pull request URL' do
      let(:origin_url)       { "git@github.com/#{user_name}/repo-name.git" }
      let(:pull_request_url) { "https://github.com/#{user_name}/repo-name/pull/18" }
      let(:branch_name)      { "#{user_name}-branch-name" }
      let(:instance)         { described_class.new(pull_request_url) }

      before do
        instance.stub(:dirty_branch?).and_return(false)
        instance.stub(:origin_url).and_return(origin_url)
        instance.stub(:checkout_pull_request_branch).and_return(branch_name)
      end

      context 'when pull request is from the same repo' do
        let(:user_name) { 'user' }

        it 'gets plain branch name out of pull request' do
          expect(instance).to receive(:substitute_prefix)
          instance.perform
        end

        it 'handles plain branch name' do
          expect(instance).to receive(:handle_branch_name)
          instance.perform
        end

        it 'deletes temporary branch' do
          expect(instance).to receive(:delete_branch).with(branch_name)
          instance.perform
        end
      end

      context 'when pull request is from the fork' do
        let(:user_name) { 'forked-user' }

        it 'creates branch locally with fork prefix' do
          expect(instance).to receive(:checkout_pull_request_branch)
          instance.perform
        end
      end
    end
  end
end

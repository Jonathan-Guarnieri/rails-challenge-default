require 'rails_helper'

RSpec.describe GenerateAccountKeyJob, type: :job do
  let(:user) { create(:user) }

  describe "#perform" do
    before do
      allow(AccountKeyService).to receive(:generate_account_key).and_return("new_account_key")
    end

    it "generates and updates the account key for the user" do
      expect(AccountKeyService).to receive(:generate_account_key).with(user.email, user.key).and_return("new_account_key")
      
      described_class.new.perform(user.id)
      
      user.reload
      expect(user.account_key).to eq("new_account_key")
    end

    it "retries the job if an exception occurs" do
      allow(User).to receive(:find).with(user.id).and_return(user)
      allow(AccountKeyService).to receive(:generate_account_key).and_raise(StandardError.new("some error"))

      expect(Rails.logger).to receive(:error).with("Failed to generate account key for user #{user.id}: some error")
      expect {
        described_class.new.perform(user.id)
      }.to raise_error(StandardError, "some error")
    end
  end
end

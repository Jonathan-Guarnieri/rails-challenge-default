class GenerateAccountKeyJob < ApplicationJob
  sidekiq_options retry: 5

  def perform(user_id)
    user = User.find(user_id)
    account_key = AccountKeyService.generate_account_key(user.email, user.key)
    user.update!(account_key: account_key)
    user.save!
  rescue => e
    Rails.logger.error "Failed to generate account key for user #{user_id}: #{e.message}"
    raise e # Re-raise the exception to trigger a retry
  end
end

require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  let!(:user1) { create(:user, created_at: 1.day.ago) }
  let!(:user2) { create(:user, created_at: 2.days.ago) }
  let(:response_body) { JSON.parse(response.body) }

  describe "GET #index" do
    it "returns all users in descending order of creation" do
      get :index

      expect(response).to have_http_status(:ok)
      expect(response_body['users']).to be_an_instance_of(Array)
      expect(response_body['users'].count).to eq(2)
      expect(response_body['users'].first['key']).to eq(user1.key)
      expect(response_body['users'].last['key']).to eq(user2.key)
    end

    it "returns all necessary fields" do
      required_fields = %w[email phone_number full_name key account_key metadata]

      get :index

      expect(response_body['users']).to be_an_instance_of(Array)
      expect(response_body['users'].count).to eq(2)
      expect(response_body['users'].first.keys).to match_array(required_fields)
    end
  end
end

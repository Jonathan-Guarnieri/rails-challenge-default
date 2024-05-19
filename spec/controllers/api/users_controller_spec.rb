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

  describe "POST #create" do
    let(:valid_attributes) do
      {
        email: 'user@example.com',
        phone_number: '5551235555',
        full_name: 'Joe Smith',
        password: 'securepassword',
        metadata: 'male, age 32, unemployed, college-educated'
      }
    end
    let(:invalid_attributes) do
      {
        phone_number: '',
        password: ''
      }
    end

    context 'with valid parameters' do
      it 'creates a new User' do
        expect {
          post :create, params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it 'returns a 201 status code' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
      end

      it 'returns the created user' do
        post :create, params: valid_attributes
        json_response = JSON.parse(response.body)

        expect(json_response['email']).to eq(valid_attributes[:email])
        expect(json_response['phone_number']).to eq(valid_attributes[:phone_number])
        expect(json_response['full_name']).to eq(valid_attributes[:full_name])
        expect(json_response['key']).to be_present
        expect(json_response['account_key']).to be_present
        expect(json_response['metadata']).to eq(valid_attributes[:metadata])
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect {
          post :create, params: invalid_attributes
        }.to change(User, :count).by(0)
      end

      it 'returns a 422 status code' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error messages' do
        post :create, params: invalid_attributes
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Phone number can't be blank", "Password can't be blank")
      end
    end

    context 'with a server error' do
      before do
        allow(User).to receive(:new).and_raise(StandardError, 'Something went wrong')
      end

      it 'returns a 500 status code' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:internal_server_error)
      end

      it 'returns the error message' do
        post :create, params: valid_attributes
        json_response = JSON.parse(response.body)

        expect(json_response['error']).to eq('Server error')
        expect(json_response['message']).to eq('Something went wrong')
      end
    end
  end
end

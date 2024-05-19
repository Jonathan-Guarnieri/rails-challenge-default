module Api
  class UsersController < ApplicationController
    DISPLAYABLE_FIELDS = %i(email phone_number full_name key account_key metadata).freeze

    def index
      users = User.order(created_at: :desc)

      render json: {users: users.as_json(only: DISPLAYABLE_FIELDS)}, status: :ok
    end

    def create
      user_params[:password] =  hash_password(user_params[:password])
      user = User.new(user_params.merge(
        key: generate_key,
        account_key: fetch_account_key
      ))

      if user.save
        render json: user.as_json(only: DISPLAYABLE_FIELDS), status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { error: 'Server error', message: e.message }, status: :internal_server_error
    end

    private

    def user_params
      params.permit(:email, :phone_number, :full_name, :password, :metadata)
    end

    def generate_key
      SecureRandom.hex(32)
    end

    def hash_password(password)
      BCrypt::Password.create(password)
    end

    def fetch_account_key
      # Simulate fetching an account key from an external service
      SecureRandom.hex(16)
    end
  end
end

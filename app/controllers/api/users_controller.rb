module Api
  class UsersController < ApplicationController
    DISPLAYABLE_FIELDS = %i(email phone_number full_name key account_key metadata).freeze

    def index
      users = User.order(created_at: :desc)

      render json: {users: users.as_json(only: DISPLAYABLE_FIELDS)}, status: :ok
    end
  end
end

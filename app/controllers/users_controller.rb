class UsersController < ApplicationController
  before_action :post_request_params, :only => [:sign_in]
  skip_before_action :authenticate_user_from_token, :only => [:sign_in]


  def sign_in
    if !User.exists?(email: @request_params["email"])
      errors("Invalid credentials, try again.",401)
    else
      @user = User.find_by_email("#{@request_params["email"]}")
      if @user.authenticated?(:password, @request_params["password"])
        @user.assign_authentication_token
      else
        errors("Invalid credentials, try again.",401)
      end
    end
    p @user
  end

  private

  def post_request_params
    @request_params = {}
    @request_params["password"] = request.POST.except("user")["password"]
    request.POST.except("user").each do |key,value|
      if User.has_attribute?(key)
        @request_params[key] = value
      end
    end
  end
end

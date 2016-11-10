class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :authenticate_user_from_token


  private

  def errors(error_message,code)
    render :json=> {:status=>"failure", :error=>"#{error_message}"}, :status => code
  end

  def authenticate_user_from_token
    if !request.headers["Bookstore-User-Id"].present?
      errors('All valid headers must be present', 401)
    elsif !request.headers["Bookstore-Authentication-Token"].present?
      errors('All valid headers must be present', 401)
    else
      user_id = request.headers["Bookstore-User-Id"]
      authentication_token = request.headers["Bookstore-Authentication-Token"]
      if !User.exists?(id: user_id)
        errors('All valid headers must be present', 401)
      else
        @user = User.find(user_id.to_i)
        if !@user.authenticated?(:authentication_token, authentication_token)
          errors('Invalid credentials, try again', 401)
        end
      end
    end
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :authenticate_user_from_token

  def authenticate_user_from_token
    if !request.headers["Bookstore-User-Id"].present?
      raise errors(t('All valid headers must be present'), 401)
    elsif !request.headers["Bookstore-Authentication-Token"].present?
      raise errors(t('All valid headers must be present'), 401)
    else
      user_id = request.headers["Bookstore-User-Id"]
      authentication_token = request.headers["Bookstore-Authentication-Token"]
      if !User.exists?(id: user_id)
        raise errors(t('All valid headers must be present'), 401)
      else
        @user = User.find(user_id.to_i)
        if !@user.authenticated?(:authentication_token, authentication_token)
          raise errors(t('Invalid credentials, try again'), 401)
        elsif @user.authentication_token_expiry_date < Time.now
          raise errors(t('Invalid credentials, try again'), 401)
        end
      end
    end
  end
end

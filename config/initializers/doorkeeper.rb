OTP_HEADER = 'X-Amber-OTP'.freeze

Doorkeeper.configure do
  orm :active_record

  use_refresh_token

  # See https://github.com/doorkeeper-gem/doorkeeper/wiki/Using-Resource-Owner-Password-Credentials-flow
  grant_flows %w[password authorization_code client_credentials]

  resource_owner_from_credentials do
    user = User.activated.login_enabled.find_by(username: params[:username])

    if user.try(:authenticate, params[:password])
      if user.otp_required?
        one_time_password = request.headers[OTP_HEADER]
        if !one_time_password
          response.headers[OTP_HEADER] = 'required'
          nil
        elsif user.authenticate_otp(one_time_password)
          user
        else
          response.headers[OTP_HEADER] = 'invalid'
          nil
        end
      else
        user
      end
    end
  end

  resource_owner_authenticator do
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end

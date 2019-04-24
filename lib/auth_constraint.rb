class AuthConstraint
  def self.sidekiq?(request) # rubocop:disable Metrics/AbcSize
    return false if request.cookie_jar['ember_simple_auth-session'].blank?

    token = JSON.parse(request.cookie_jar['ember_simple_auth-session']).dig('authenticated',
                                                                            'access_token')
    Rails.cache.fetch(token, expires_in: 1.minute) do
      user_id = Doorkeeper::AccessToken.find_by(token: token).resource_owner_id
      User.sidekiq_access.login_enabled.exists?(user_id)
    end
  end
end

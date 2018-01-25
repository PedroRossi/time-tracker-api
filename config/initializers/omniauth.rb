Rails.application.config.x.settings["oauth2"] = {} if Rails.env.test?

# [START omniauth_configuration]
Rails.application.config.middleware.use OmniAuth::Builder do
  config = YAML.load_file("#{Rails.root}/config/settings.yml")[Rails.env]["oauth2"]

  provider :google_oauth2, config["client_id"],
                           config["client_secret"],
                           image_size: 150
end
# [END omniauth_configuration]

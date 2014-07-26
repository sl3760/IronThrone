OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '710997245604210', 'cdf0c7ffde7739cabdd8612c4065f094', {:client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}
end

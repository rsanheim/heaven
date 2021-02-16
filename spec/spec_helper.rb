RSpec.configure do |config|
  config.order = "random"
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false

  config.before do
    ENV["GITHUB_CLIENT_ID"]     = "<unknown-client-id>"
    ENV["GITHUB_CLIENT_SECRET"] = "<unknown-client-secret>"
    Resque.inline = true
  end

  config.around do |example|
    original = Heaven.redis._client.db
    Heaven.redis.select(15)
    example.run
    Heaven.redis.flushall
    Heaven.redis.select(original)
  end
end

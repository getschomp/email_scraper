# file will always be loaded, without a need to explicitly require it in any
# files. keep this file as light-weight as possible.

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
require 'email_scraper_app/email_scraper'
require 'email_scraper_app/web_address_scraper'
require 'email_scraper_app/email_collection'
require 'email_scraper_app/headless_browser'
require 'email_scraper_app/web_address'
require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = true
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
end

Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :poltergeist
end

RSpec.configure do |config|

config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  begin
    config.filter_run :focus
    config.run_all_when_everything_filtered = true
    config.example_status_persistence_file_path = "spec/examples.txt"
    config.disable_monkey_patching!
    config.warnings = true
    if config.files_to_run.one?
      config.default_formatter = 'doc'
    end
    config.profile_examples = 10
    config.order = :random
    Kernel.srand config.seed
  end

end

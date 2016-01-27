require 'capybara/poltergeist'

module HeadlessBrowser

  include Capybara::DSL

  attr_accessor :session

  # Create a new PhantomJS session in Capybara
  def new_session
    Capybara.configure do |c|
      c.javascript_driver = :poltergeist
      c.default_driver = :poltergeist
    end
    # Register PhantomJS (aka poltergeist) as the driver to use
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app,
        js_errors: false,
        phantomjs_logger: @file = File.open("log/phantomjs.log", "a"),
        timeout: 60
      )
    end
    # Use XPath as the default selector for the find method
    Capybara.default_selector = :xpath
    # Start up a new thread
    @session = Capybara::Session.new(:poltergeist)
    # Report using a particular user agent
    @session.driver.headers = { 'User-Agent' =>
      "Mozilla/5.0 (Macintosh; Intel Mac OS X)" }
    # Return the driver's session
    @session
  end

  def quit
    @session.driver.quit
    @file.close
  end

end

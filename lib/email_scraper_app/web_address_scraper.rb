require_relative 'headless_browser'

class WebAddressScraper

  include HeadlessBrowser

  attr_accessor :document, :web_address, :intended_domain


  def initialize(web_address = nil, intended_domain)
      new_session
      # the guard statement, allows tests set up using vcr
      return if !web_address
      # TODO:Refactor to initiate a headless browser session only once for both
      #scraper classes
      @web_address = web_address
      visit(@web_address.uri)
      @intended_domain = intended_domain
      @document = Nokogiri::HTML(html)
    rescue Capybara::Poltergeist::TimeoutError
    ensure
      quit
  end

  def find
    uris = find_html_links.concat(find_angular_links).compact
    uris.map! { |uri| WebAddress.new(uri, @intended_domain) }
    uris.select { |web_address| web_address.is_valid? }
  end

  private

  def find_html_links
    links = @document.css('a').map { |link| link.attributes["href"] }.compact
    links.map(&:value) || []
  end

  def find_angular_links
    ng_clicks = @document.xpath('//*').select do |node|
      node = node.attributes.has_key?('ng-click')
    end.map { |node| node.attributes["ng-click"].value }
    change_route = 'changeRoute(\''
    ng_clicks.select! { |js| js.include?(change_route) }
    links = ng_clicks.map do |route|
      route.chomp('\')').gsub(change_route, '')
    end.uniq! || []
  end

end

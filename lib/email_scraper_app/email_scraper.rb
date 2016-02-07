require 'open-uri'
require 'mail'
require_relative 'email_collection'
require_relative 'headless_browser'

class EmailScraper
# Run the scraper with EmailScraper.new('website_path').find

  include HeadlessBrowser

  attr_accessor :document

  def initialize(website_path = nil)
      new_session
      return if !website_path
      @home_page = website_path
      visit(@home_page)
      @document = Nokogiri::HTML(html)
    rescue Capybara::Poltergeist::TimeoutError
    ensure
      quit
  end

  def find
    emails = EmailCollection.new
    emails.all = find_within_webpage_text.concat(
      find_within_link_tags
    )
    emails.all.map { |email| Mail::Address.new(email) }
  end

  private

  def document_without_tags
    # remove non-breaking spaces and html tags
    @document.xpath("//text()").to_s
  end

  def find_within_webpage_text
    words = document_without_tags.split(' ')
    non_breaking_space = 160.chr("UTF-8")
    words = words.flat_map { |w| w.split(non_breaking_space) }
    # Note: Regex will find strings with one @, and a period following
    # there are characters before and after each @ and .
    emails = words.grep(/^[^@]+@[^@]+\.[^@]+$/)
  end

  def find_within_link_tags
    links = @document.css('a').map { |link| link.attributes["href"] }.compact
    links = links.map(&:value).map { |link| link.gsub('mailto:', '') }
    links.grep(/^[^@]+@[^@]+\.[^@]+$/)
  end

end

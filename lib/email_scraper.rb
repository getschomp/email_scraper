require 'open-uri'
require 'mail'
require 'email_collection'

class EmailScraper
# Run the scraper with EmailScraper.new('website_path').find

  attr_accessor :document

  def initialize(website_path = nil)
    @document = Nokogiri::HTML(open(website_path)) if website_path
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

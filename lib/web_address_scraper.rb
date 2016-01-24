class WebAddressScraper
# Run the scraper with WebAddressScraper.new('website_path').find

    attr_accessor :document

    def initialize(website_path = nil)
      @document = Nokogiri::HTML(open(website_path)) if website_path
    end

    def find
      links = @document.css('a').map { |link| link.attributes["href"] }.compact
      links = links.map(&:value)
    end

end

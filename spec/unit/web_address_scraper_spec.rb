require 'nokogiri'
require 'vcr'
require 'pry'
require 'webmock'

RSpec.describe WebAddressScraper do

  describe '.find' do

    context 'within an anchor tag not generated after DOM loaded' do

    # using vcr when possible for less external dependencies
      before(:each) do
        VCR.use_cassette("tumblr") do
          @scraper = WebAddressScraper.new
          @scraper.web_address = WebAddress.new('https://www.tumblr.com/', 'tumblr.com')
          response = Net::HTTP.get_response(URI(@scraper.web_address.uri))
          @scraper.document = Nokogiri::HTML(response.body)
          @web_addresses = @scraper.find.map(&:uri)
        end
      end

      it 'finds a link within the same domain ' do
        expect(@web_addresses).to include('https://www.tumblr.com/jobs')
      end

      it 'rejects a link outside the domain' do
        outside_link = "https://app.appsflyer.com/id305343404?pid=tumblr_internal&amp;c=signup_page"
        expect(@web_addresses).not_to include(outside_link)
      end
    end

    context 'with links generated by javascript' do

      before(:each) do
        web_address = WebAddress.new('https://www.jana.com/', 'jana.com')
        @scraper = WebAddressScraper.new(web_address, 'jana.com')
        @web_addresses = @scraper.find.map(&:uri)
      end

      it 'finds a links on the page within the domain' do
        expect(@web_addresses).to include(@scraper.uri + 'contact')
      end

    end

  end

end

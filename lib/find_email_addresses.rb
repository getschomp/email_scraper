require_relative 'email_scraper_app/web_address_scraper'
require_relative 'email_scraper_app/headless_browser'
require_relative 'email_scraper_app/email_scraper'
require_relative 'email_scraper_app/email_collection'
require_relative 'email_scraper_app/web_address'
require 'pry'

class MainExecution

  def initialize
      intended_domain = ARGV[0]
      address = WebAddress.new("https://www.#{intended_domain}", intended_domain)
      @emails = []
      create_buckets(address)
      loop_scrapers([address], intended_domain)
    rescue StandardError => e
      puts e
    ensure
      puts @emails.uniq(&:address)
  end

  def create_buckets(address)
    @recorded_addresses = [address]
    @visited_addresses = []
  end

  def loop_scrapers(web_addresses, intended_domain)
    if web_addresses.empty?
      web_addresses = @recorded_addresses.reject { |a| @visited_addresses.map(&:uri).include?(a.uri) }
    end
    return if @recorded_addresses.map(&:uri) == @visited_addresses.map(&:uri)
    web_addresses.each do |web_address|
      if !@visited_addresses.include?(web_address)
        web_addresses = visit_address(web_address, intended_domain)
      end
    end
    return if web_addresses == nil
    loop_scrapers(web_addresses, intended_domain)
  end


  def visit_address(web_address, intended_domain)
    @visited_addresses << web_address
    email_scraper = EmailScraper.new(web_address.uri)
    web_scraper = WebAddressScraper.new(web_address, intended_domain)
    if web_scraper.document
      @emails = @emails + email_scraper.find
      web_addresses = web_scraper.find
      web_addresses.reject! { |a| @recorded_addresses.map(&:uri).include?(a.uri) }
      @recorded_addresses = @recorded_addresses + web_addresses
      @recorded_addresses = @recorded_addresses.uniq(&:uri).sort_by(&:uri)
      @visited_addresses = @visited_addresses.uniq(&:uri).sort_by(&:uri)
    end
    web_addresses || []
  end

end

MainExecution.new

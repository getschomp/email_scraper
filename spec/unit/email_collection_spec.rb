RSpec.describe EmailCollection do

  describe '.validate_email_domains' do

    before(:each) do
      file_path = File.expand_path("../../", __FILE__) + '/jana_contact.html'
      scraper = EmailScraper.new
      scraper.document = File.open(file_path) { |file| Nokogiri::HTML(file) }
      @emails = scraper.find.map(&:address)
    end

    it 'rejects emails without an mx domain' do
      expect(@emails).not_to include('allison@thisisdefinitlynotadomain.mx')
    end

  end

end

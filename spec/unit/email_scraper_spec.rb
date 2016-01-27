require 'nokogiri'

RSpec.describe EmailScraper do

  # An addr-spec is a specific Internet identifier that contains a locally
  # interpreted string followed by the at-sign character ("@", ASCII value 64)
  # followed by an Internet domain.  The locally interpreted string is either a
  # quoted-string or a dot-atom.

  describe '.find' do

    #TODO: switch to VCR here and consolidate methods
    before(:each) do
      file_path = File.expand_path("../../", __FILE__) + '/jana_contact.html'
      scraper = EmailScraper.new
      scraper.document = File.open(file_path) { |file| Nokogiri::HTML(file) }
      @emails = scraper.find.map(&:address)
    end

    context 'within the document text and surrounded by spaces' do
      it 'finds an email' do
        expect(@emails).to include('bob@gmail.com')
      end
    end

    context 'within an non-breaking space' do
      it 'finds an email' do
        expect(@emails).to include('sales@jana.com')
      end
    end

    context 'with a link tag' do
      it 'finds an email' do
        expect(@emails).to include('more_info@jana.com')
      end
    end

    context 'with trailing non-alphanumeric characters' do
      it 'finds an email' do
        expect(@emails).to include('jon@exact.ly')
        expect(@emails).to include('allison@gmail.com')
      end
    end

  end

end

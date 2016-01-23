require 'spec_helper'
require "rspec"

RSpec.describe EmailScrapper do

  # An addr-spec is a specific Internet identifier that contains a locally
  # interpreted string followed by the at-sign character ("@", ASCII value 64)
  # followed by an Internet domain.  The locally interpreted string is either a
  # quoted-string or a dot-atom.

  describe '.find_within' do
    before(:each) do
      file_path = File.expand_path("../../", __FILE__) + '/spec/jana_contact.html'
      @contact_page = File.open(file_path) { |file| Nokogiri::HTML(file) }
      @scrapper = EmailScrapper.new
    end

    context 'within the document text and surrounded by spaces' do
      it 'finds an email' do
        expect @email_scrapper.find_within(@contact_page).to include('bob@gmail.com')
      end
    end

    context 'within an html link tag' do
      it 'finds an email' do
        expect @scrapper.find_within(@contact_page).to include('sales@jana.com')
      end
    end

    context 'with trailing non-alphanumeric characters' do
      it 'finds an email' do
        expect @scrapper.find_within(@contact_page).to include('jon@exact.ly')
        expect @scrapper.find_within(@contact_page).to include('allison@gmail.com')
      end
    end
  end

  # describe '.validate_email' do
  #   it 'rejects emails without an mx domain' do
  #
  #   end
  # end

end

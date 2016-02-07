RSpec.describe 'Prints Emails' do
  context 'User runs find_email_addresses.rb' do
    before(:each) do
      @app_run_file_path = Dir.getwd.chomp('/spec/feature') + '/lib/find_email_addresses.rb'
    end

    it 'prints emails to the command line' do
      expect(`ruby #{@app_run_file_path} jana.com`).to include('sales@jana.com')
    end

  end
end

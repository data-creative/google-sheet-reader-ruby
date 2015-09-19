require 'spec_helper'

describe GoogleDriver do
  it 'has a version number' do
    expect(GoogleDriver::VERSION).not_to be nil
  end

  describe '#extract' do
    let(:spreadsheet_id){ ENV['GOOGLE_DRIVER_FILE_ID'] }
    let(:configuration_options){
      {
        :app_name => ENV['GOOGLE_DRIVER_APP_NAME'],
        :email_address => ENV['GOOGLE_DRIVER_EMAIL'],
        :key_file_path => File.expand_path("../key_files/#{ENV['GOOGLE_DRIVER_KEY_FILE_NAME']}", __FILE__),
        :extraction_procedure => Proc.new do |row|
          "PARSING A SPREADSHEET ROW HERE -- #{row.inspect}"
        end
      }
    }

    it 'needs a .p12 key_file' do
      puts configuration_options[:key_file_path]
      expect(File.exist?(configuration_options[:key_file_path])).to eq(true)
    end

    it 'extracts spreadsheet data' do
      process = GoogleDriver.extract(spreadsheet_id, configuration_options)

      expect(process[:status]).to eql("SUCCESS")
      expect(process[:row_count] > 0)
    end
  end
end

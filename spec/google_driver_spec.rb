require 'spec_helper'

describe GoogleDriver do
  it 'has a version number' do
    expect(GoogleDriver::VERSION).not_to be nil
  end

  describe '#extract' do
    let(:document_id){ ENV['GOOGLE_DRIVER_FILE_ID'] }
    let(:options){
      {
        :app_name => ENV['GOOGLE_DRIVER_APP_NAME'],
        :email_address => ENV['GOOGLE_DRIVER_EMAIL'],
        :key_file_path => File.expand_path("../key_file/#{ENV['GOOGLE_DRIVER_KEY_FILE_NAME']}", __FILE__),
        :extraction_procedure => Proc.new do |row|
          "PARSING A SPREADSHEET ROW HERE -- #{row.inspect}"
        end
      }
    }

    it 'extracts spreadsheet data' do
      GoogleDriver.extract(document_id, options)

      puts options[:key_file_path]

      expect(File.exist?(options[:key_file_path])).to eq(true)
    end
  end
end

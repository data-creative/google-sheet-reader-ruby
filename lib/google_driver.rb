require 'google/api_client'
require 'csv'

require "google_driver/version"

module GoogleDriver

  def self.client(options = {})
    app_name = options[:app_name]
    email_address = options[:email_address]
    key_file_path = options[:key_file_path]

    key = Google::APIClient::KeyUtils.load_from_pkcs12(key_file_path, 'notasecret')
    asserter = Google::APIClient::JWTAsserter.new(email_address, 'https://www.googleapis.com/auth/drive', key)
    google_api_client = Google::APIClient.new({:application_name => app_name, :application_version => "1.0"})
    google_api_client.authorization = asserter.authorize()
    return google_api_client
  end

  # Extract data from a Google Drive spreadsheet.
  #
  # @param [String] spreadsheet_id
  # @param [Hash] options [String] app_name
  # @param [Hash] options [String] email_address
  # @param [Hash] options [String] key_file_path
  # @param [Hash] options [Proc] extraction_procedure
  #
  # @example GoogleDriver.extract(file_id, opts)
  #
  def self.extract(spreadsheet_id, options = {})
    app_name = options[:app_name]
    email_address = options[:email_address]
    key_file_path = options[:key_file_path]
    extraction_procedure = options[:extraction_procedure]

    puts "CONNECTING TO GOOGLE DRIVE ..."

    google_api_client = self.client(options)
    drive = google_api_client.discovered_api('drive', 'v2')

    get_request_result = google_api_client.execute(
      :api_method => drive.files.get,
      :parameters => { 'fileId' => spreadsheet_id }
    )
    raise FileRetrievalError unless get_request_result.status == 200

    file = get_request_result.data
    download_url = file.exportLinks["text/csv"]
    raise FileDownloadLinkError unless download_url

    download_request_result = google_api_client.execute(:uri => download_url)
    raise FileDownloadError unless download_request_result.status == 200

    file_contents = download_request_result.body
    csv_result = CSV.parse(file_contents, headers:true)
    #headers = csv_result.headers

    raise EmptyFileError.new("This spreadsheet has no data. Please add rows.") unless csv_result.any?

    csv_result.each do |row|
      extraction_procedure.call(row)
    end

    puts "PARSED #{csv_result.count} ROWS"
    return {:status => "SUCCESS", :row_count => csv_result.count}
  end

  class FileRetrievalError < StandardError ; end
  class FileDownloadLinkError < StandardError ; end
  class FileDownloadError < StandardError ; end
  class EmptyFileError < StandardError ; end
end

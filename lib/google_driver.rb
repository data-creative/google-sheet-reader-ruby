require "google_driver/version"

module GoogleDriver

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

    puts "CONNECTING TO GOOGLE DRIVE"

    spreadsheet_name = "todo"

    puts "EXTRACTING #{spreadsheet_name}"

    # todo
  end
end

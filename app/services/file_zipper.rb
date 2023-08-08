# frozen_string_literal: true

class FileZipper
  attr_reader :input_file, :tempfile

  def initialize(input_file:)
    @input_file = input_file
    @tempfile = Tempfile.new
  end

  def zip
    buffer = Zip::OutputStream.write_buffer(StringIO.new, encrypter) do |output|
      output.put_next_entry(input_file.original_filename)
      output.write input_file.tempfile.read
    end

    File.open(zip_filename, 'wb') {|f| f.write(buffer.string) }

    true
  end

  def file
    File.new(zip_filename)
  end

  def password
    @password ||= SecureRandom.hex(15)
  end

  private

  def encrypter
    Zip::TraditionalEncrypter.new(password)
  end

  def zip_filename
    "#{tempfile.path}.zip"
  end
end

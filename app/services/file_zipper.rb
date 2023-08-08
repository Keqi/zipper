# frozen_string_literal: true

class FileZipper
  attr_reader :file, :tempfile

  def initialize(file:)
    @file = file
    @tempfile = Tempfile.new
  end

  def zip
    Zip::File.open(zip_filename, create: true) do |zipfile|
      zipfile.add(file.original_filename, file.tempfile)
    end

    File.new(zip_filename)
  end

  private

  def zip_filename
    "#{tempfile.path}.zip"
  end
end

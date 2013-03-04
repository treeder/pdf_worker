#$:.unshift File.dirname(__FILE__)
puts ENV['PATH']
ENV['PATH'] += ":" + File.dirname(__FILE__)
puts ENV['PATH']

require 'aws'
require 'pdfkit'

def upload_file(filename)
  unless params['disable_network']
    files = [filename].flatten
    files.each do |filepath|
      puts "Uploading the file to s3..."
      s3 = Aws::S3Interface.new(params['aws']['access_key'], params['aws']['secret_key'])
      s3.create_bucket(params['aws']['s3_bucket_name'])
      response = s3.put(params['aws']['s3_bucket_name'], filepath, File.open(filepath))
      if response == true
        puts "Uploading successful."
        link = s3.get_link(params['aws']['s3_bucket_name'], filepath)
        puts "\nYou can view the file here on s3: ", link
      else
        puts "Error uploading to s3."
      end
      puts "-"*60
    end
  end
end

# PDFKit.new takes the HTML and any options for wkhtmltopdf
# run `wkhtmltopdf --extended-help` for a full list of options
#kit = PDFKit.new(html, :page_size => 'Letter')
#kit.stylesheets << '/path/to/css/file'


# PDFKit.new can optionally accept a URL or a File.
# Stylesheets can not be added when source is provided as a URL of File.
kit = PDFKit.new(params[:url])
#kit = PDFKit.new(File.new('/path/to/html'))

# Add any kind of option through meta tags
#PDFKit.new('<html><head><meta name="pdfkit-page_size" content="Letter"')


# Get an inline PDF
#pdf = kit.to_pdf

# Save the PDF to a file
filename = 'my.pdf'
file = kit.to_file(filename)

upload_file filename

require 'nokogiri'
require 'net/http'
require 'pathname'
require 'open-uri'
require 'securerandom'
require 'fileutils'
require_relative 'web_page_downloader'

if __FILE__ == $PROGRAM_NAME
  if ARGV[0] == '--meta'
    log_meta_info = true
    ARGV.shift
  end
  ARGV.each do |url|
    downloader = WebPageDownloader.new(url)
    downloader.download
    downloader.meta_info if log_meta_info
  end
end

class WebPageDownloader
  attr_reader :url
  attr_writer :page

  def initialize(url)
    @url = url
  end

  def download
    return unless valid_url?

    parse_images
    parse_style_sheet
    parse_javascripts
    create_html_file
  end

  def valid_url?
    true unless content.nil?
  rescue StandardError => e
    p "Invalid url #{url}. Error - #{e}"
    false
  end

  def uri
    @uri ||= URI(url)
  end

  def domain
    @domain ||= uri.hostname
  end

  def content
    @content ||= Net::HTTP.get(uri)
  end

  def page
    @page ||= Nokogiri::HTML(content)
  end

  def uri_without_path
    @uri_without_path ||= (URI.join url, '/').to_s.chomp('/')
  end

  def website_path
    @website_path ||= "./#{domain}"
  end

  def create_html_file
    out_file = File.new("#{website_path}.html", 'w')
    out_file.puts(page)
    out_file.close
  end

  def urls_count
    page.xpath('//a/@href').count
  end

  def images_count
    page.xpath('//img[@src]').count
  end

  def meta_info
    p '---------------------------------'
    p "site: #{url}"
    p "num_links: #{urls_count}"
    p "images: #{images_count}"
    p "last_fetch: #{Time.now}"
    p '---------------------------------'
  end

  def file_path(type, extension)
    "#{website_path}/#{type}/#{SecureRandom.uuid}#{extension}"
  end

  def parse_style_sheet
    parse_assets('//link[@rel="stylesheet"]', :href, 'stylesheets')
  end

  def parse_images
    parse_assets('//img[@src]', :src, 'images')
  end

  def parse_javascripts
    parse_assets('//script[@src]', :src, 'scripts')
  end

  def parse_assets(xpath, tag, type)
    page.xpath(xpath).each do |component|
      component_url = component[tag]
      extension = File.extname(component_url)
      path = file_path(type, extension)
      external = component_url =~ URI::DEFAULT_PARSER.make_regexp
      external ? download_asset(component_url, path) : download_asset("#{uri_without_path}#{component[tag]}", path)
      component[tag] = path
    rescue StandardError => e
      p "An error of type #{e.class} happened, message is #{e.message}"
    end
    self.page = page
  end

  def download_asset(url, path)
    return if url.to_s.start_with?('data:')

    dir = File.dirname(path)
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    File.new(path, 'w')
    File.write path, URI.open(url).read
  rescue StandardError => e
    p "An error of type #{e.class} happened, message is #{e.message}"
  end
end

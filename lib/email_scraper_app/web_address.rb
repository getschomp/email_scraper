require 'uri'

class WebAddress

  attr_accessor :uri, :domain, :intended_domain

  def initialize(uri, intended_domain)
    @intended_domain = intended_domain
    uri = fill_in_prefix(uri) if !uri.include?('.') && uri[0] && uri
    @uri = uri
  end

  def is_valid?
      return domain(@uri) == @intended_domain
    rescue
      false
  end

  def fill_in_prefix(uri)
    if uri[0] == '/'
      "https://www.#{@intended_domain}#{uri}"
    elsif uri[0].respond_to?(:match) && uri[0].match(/[a-z]/)
      "https://www.#{@intended_domain}/#{uri}"
    end
  end

  def domain(uri)
    #if it dosn't have https then add it in so the host can be parsed by URI
    uri = "https://#{uri}" if URI.parse(uri).scheme.nil?
    host = URI.parse(uri).host
    host.slice!(0..3) if host.start_with?('www.')
    host
  end

end

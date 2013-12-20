require "24.03.htmlscanner"
require "get_links_from_html"

class ClientController < ApplicationController
  def index
    if params[:url].present?
    @urls = get_links(params[:url])
    else
      @urls = []
    end
  end

  def get_links(url)
    #data =  RestClient.get("http://baidu.com")
    file = File.join(Rails.root, "doc", "baidu.html")
    data =  open(file){|io| io.read }

    #puts "****************"
    #puts data

    list = getlinks(data)
    urls = list.select{|link|
      /^http:/ =~ link.url
    }
  end
end

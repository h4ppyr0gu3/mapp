require 'net/http'
require 'json'

class SearchController < ApplicationController
  def get
    api = Invidious.api
    uri = URI("#{api}/api/v1/trending?type=Music")
    res = Net::HTTP.get(uri)
    @trending = JSON.parse(res)
  end

  def post
    query_params
    if params[:commit] == "Search"
      @value = params[:query]
      if (params[:query] =~ /\A(http|https):\/\/*/)
        query = params[:query].split(".")
        if query.includes?("youtube")
          # begin download
        end
      else
        @value
        api = Invidious.api
        q = CGI.escape(@value)
        url = "#{api}/api/v1/search?q=#{q}"
        url += "&sort=#{CGI.escape(params[:sort_by])}"
        url += "&date=#{CGI.escape(params[:date])}" unless params[:date] == ""
        @prev_url = url
        search(url)
      end
      else
        handle_pagination
      end
      # search db
  end

  def search(url)
    uri = URI(url)
    res = Net::HTTP.get_response(uri)
    res = Net::HTTP.get(uri) unless res.class == Net::HTTPOK

    @response = JSON.parse(res.body)
  end


  def handle_pagination
    @value = params[:query]
    if params[:commit] == "Next"
      url = @prev_url = params[:prev_url]
      params[:page] = "1" if params[:page] == ""
      @page = (params[:page].to_i + 1).to_s
      url += "&page=#{@page}"
      search(url)
    else params[:commit] == "Prev"
      url = @prev_url = params[:prev_url]
      @page = (params[:page].to_i - 1).to_s
      if params[:page].present? && params[:page].to_i > 1
        url += "&page=#{@page}"
        search(url)
      end
    end
  end

  private

  def query_params
    params.permit(
      :prev_url,
      :date,
      :sort_by,
      :page,
      :query,
      :authenticity_token,
      :commit
    )
  end
end

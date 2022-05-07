# frozen_string_literal: true

require 'net/http'
require 'json'

class SearchController < ApplicationController
  include SearchHelper
  def get
    api = Invidious.api
    uri = URI("#{api}/api/v1/trending?type=Music")
    res = Net::HTTP.get(uri)
    @trending = JSON.parse(res)
  end

  def post
    query_params
    @value = params[:query]
    @response = if params[:commit] == 'Search'
                  handle_search
                else
                  handle_pagination
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

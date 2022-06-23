# frozen_string_literal: true

require "net/http"
require "json"

class SearchController < ApplicationController
  before_action :authenticate_user!

  include SearchHelper

  def get
    res = Rails.cache.fetch("trending", expires_in: 1.hours) do
      trending
    end
    ActionCable.server.broadcast 'notifications_channel', "here is a test"
    @trending = JSON.parse(res)
  end

  def post
    query_params
    @value = params[:query]
    @response = if params[:commit] == "Search"
                  handle_search
                else
                  handle_pagination
                end
  end

  private

  def trending
    api = Invidious.api
    uri = URI("#{api}/api/v1/trending?type=Music")
    Net::HTTP.get(uri)
  end

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

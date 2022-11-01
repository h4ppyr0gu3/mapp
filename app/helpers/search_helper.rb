# frozen_string_literal: true

module SearchHelper
  def handle_search
    if link?
      query = params[:query].split(".")
      download_link(query) if query.include?("youtube")
      redirect_to search_path, notice: "Download started"
    else
      url = generate_url
      @prev_url = url
      search(url)
    end
  end

  def download_link(query)
    video = query[-1].gsub("com/watch?v=", "")
    video_id = video.split("&")[0]
    url = "#{Invidious.api}/api/v1/videos/#{video_id}"
    response = search(url)
    job_params = strict_params(video_id, response, current_user).to_json
    DownloadJob.perform_async(job_params)
  end

  def strict_params(video_id, response, current_user)
    {
      video_id: video_id,
      image_url: "https://img.youtube.com/vi/#{video_id}/hqdefault.jpg",
      title: response["title"],
      channel: response["author"],
      user_id: current_user.id
    }
  end

  def generate_url
    api = Invidious.api
    q = CGI.escape(params[:query])
    url = "#{api}/api/v1/search?type=video&q=#{q}+audio"
    url += "&sort=#{CGI.escape(params[:sort_by])}"
    url += "&date=#{CGI.escape(params[:date])}" unless params[:date] == ""
    url
  end

  def link?
    params[:query] =~ %r{\A(http|https)://*}
  end

  def search(url)
    uri = URI(url)
    res = Net::HTTP.get_response(uri)
    unless res.instance_of?(Net::HTTPOK)
      Rails.cache.delete("active_api")
      uri = URI(generate_url)
    end
    res = Net::HTTP.get(uri) unless res.instance_of?(Net::HTTPOK)

    JSON.parse(res.body)
  end

  def handle_pagination
    @value = params[:query]
    case params[:commit]
    when "Next"
      handle_next_page
    when "Prev"
      handle_prev_page
    end
  end

  def handle_prev_page
    url = @prev_url = params[:prev_url]
    @page = (params[:page].to_i - 1).to_s
    return unless params[:page].present? && params[:page].to_i > 1

    url += "&page=#{@page}"
    search(url)
  end

  def handle_next_page
    url = @prev_url = params[:prev_url]
    params[:page] = "1" if params[:page] == ""
    @page = (params[:page].to_i + 1).to_s
    url += "&page=#{@page}"
    search(url)
  end
end

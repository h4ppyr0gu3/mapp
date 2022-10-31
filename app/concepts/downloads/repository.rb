# frozen_string_literal: true

module Downloads
  class Repository
    class << self
      def update_metadata(song)
        song.update_metadata
      end

      def add_song_params(song)
        song.update(
          artist: (song.artist.nil? ? "unknown" : song.artist),
          year: (song.year.nil? ? "unknown" : song.year),
          genre: (song.genre.nil? ? "unknown" : song.genre),
          album: (song.album.nil? ? "unknown" : song.album)
        )
      end

      def call_download_job(params)
        job_params = strict_params(params).to_json
        DownloadJob.perform_async(job_params)
      end

      def strict_params(params)
        {
          video_id: params["video_id"],
          image_url: params["image_url"],
          title: params["title"],
          channel: params["channel"],
          user_id: params["user_id"]
        }
      end
    end
  end
end

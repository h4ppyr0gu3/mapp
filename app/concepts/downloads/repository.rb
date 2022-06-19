# frozen_string_literal: true

module Downloads
  class Repository
    class << self
      def update_metadata(song)
        uri = URI("#{ENV.fetch('IDEDIT_URL', nil)}/edit")
        id_params = set_params(song)
        return if id_params.nil?

        res = Net::HTTP.post_form(uri, id_params)
        return unless res.instance_of?(Net::HTTPOK)

        body = res.body.to_s.force_encoding("ASCII-8BIT")
        write_and_update(song, body) unless res.body.nil?
      end

      def write_and_update(song, body)
        song.mp3.purge
        path = Rails.root.join("tmp", "downloads", "idedit", "#{song.title}.mp3")
        File.binwrite(path, body)
        song.mp3.attach(
          io: File.open(path),
          filename: "#{song.title}.mp3"
        )
        system("rm '#{path}'") if song.mp3.attached?
        song.update(updated: 2)
      end

      def add_song_params(song)
        song.update(
          artist: (song.artist.nil? ? "unknown" : song.artist),
          year: (song.year.nil? ? "unknown" : song.year),
          genre: (song.genre.nil? ? "unknown" : song.genre),
          album: (song.album.nil? ? "unknown" : song.album)
        )
      end

      def update_song_attributes(song); end

      # rubocop:disable Metrics/MethodLength
      def set_params(song)
        add_song_params(song)
        return nil unless song.mp3.attached?

        begin
          mp3 = song.mp3.download
          image = song.image.download
        rescue ActiveStorage::FileNotFoundError
          song.delete
          return nil
        end

        { image:,
          file: mp3,
          title: song.title,
          artist: song.artist,
          year: song.year,
          genre: song.genre,
          album: song.album }
      end
      # rubocop:enable Metrics/MethodLength

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

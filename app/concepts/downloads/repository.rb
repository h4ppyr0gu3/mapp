# frozen_string_literal: true

module Downloads
  class Repository
    class << self
      def update_metadata(song)
        song_file_path = Rails.root.join("tmp", "downloads", "#{song.video_id}.mp3").to_s
        new_song_file_path = Rails.root.join("tmp", "downloads", "new_#{song.video_id}.mp3").to_s
        image_file_path = Rails.root.join("tmp", "downloads", "#{song.video_id}.jpg").to_s
        File.binwrite(song_file_path, song.mp3.download)
        File.binwrite(image_file_path, song.image.download)
        system_command = "ffmpeg -i #{song_file_path} -i #{image_file_path} -map 0:a -map 1:0 -id3v2_version 4 " +
                         create_ffmpeg_metadata_string(song) + " " + new_song_file_path
        system(system_command)
        song.mp3.purge if song.mp3.attached?
        song.mp3.attach(
          io: File.open(new_song_file_path),
          filename: "#{song.title}.mp3"
        )
        system("rm #{new_song_file_path} #{song_file_path} #{image_file_path}") if song.mp3.attached?
        song.update(updated: 2)
      end

      # rubocop:disable Metrics:AbcComplexity
      def create_ffmpeg_metadata_string(song)
        # metadata << "-metadata title='#{song.title}'" if song.title != nil
        # metadata << "-metadata album_artist='London Symphony'"
        # metadata << "-metadata track='#{song.track_no}'"
        metadata = []
        metadata << "-metadata title='#{song.title}'" unless song.title.nil?
        metadata << "-metadata artist='#{song.artist}'" unless song.artist.nil?
        metadata << "-metadata album='#{song.album}'" unless song.album.nil?
        metadata << "-metadata date='#{song.year}'" unless song.year.nil?
        metadata << "-metadata genre='#{song.genre}'" unless song.genre.nil?
        metadata.join(" ")
      end
      # rubocop:enable Metrics:AbcComplexity

      def write_to_local_file_system(song); end

      def write_and_update(song, body)
        song.mp3.purge
        path = Rails.root.join("tmp", "downloads", "idedit", "#{song.video_id}.mp3")
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
          title: song.title.gsub("/", " "),
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

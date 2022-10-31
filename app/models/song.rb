# frozen_string_literal: true

class Song < ApplicationRecord
  has_one_attached :image
  has_one_attached :mp3
  has_many :user_songs, dependent: :destroy
  has_many :users, through: :user_songs
  has_many :device_songs, dependent: :destroy
  has_many :devices, through: :device_songs
  validates :title, presence: true
  validates :video_id, presence: true, uniqueness: true

  enum updated: { vanilla: 0, by_the_user: 1, written: 2 }

  def redownload
    # redownload the file then attach the mp3 file
  end
end

# frozen_string_literal: true

class Song < ApplicationRecord
  has_one_attached :image
  has_one_attached :mp3
  has_many :user_songs
  has_many :users, through: :user_songs
  has_many :device_songs
  has_many :devices, through: :device_songs
  validates :title, presence: true
end

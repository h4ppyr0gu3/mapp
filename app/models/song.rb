class Song < ApplicationRecord
  has_one_attached :image
  has_one_attached :mp3
  has_many :user_songs
  has_many :users, through: :user_songs
end

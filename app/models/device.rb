# frozen_string_literal: true

class Device < ApplicationRecord
  belongs_to :user
  has_many :device_songs
  has_many :songs, through: :device_songs
end

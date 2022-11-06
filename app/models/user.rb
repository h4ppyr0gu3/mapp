# frozen_string_literal: true

class User < ApplicationRecord
  include DeviseTokenAuth::Concerns::User
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :confirmable, :omniauthable, :validatable
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable

  has_many :user_songs
  has_many :songs, through: :user_songs
  has_many :notifications
  has_many :devices
end

# frozen_string_literal: true

class DeviceSong < ApplicationRecord
  belongs_to :song
  belongs_to :device
end

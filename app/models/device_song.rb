class DeviceSong < ApplicationRecord
  belongs_to :song
  belongs_to :device
end

class Notification < ApplicationRecord
  belongs_to :user, dependent: :destroy
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe Song, type: :model do
  describe "associations" do
    it { should have_many(:users) }
    it { should have_many(:devices) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:video_id) }
    it { should validate_uniqueness_of(:video_id) }
  end
end

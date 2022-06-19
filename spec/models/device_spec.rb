# frozen_string_literal: true

require "rails_helper"

RSpec.describe Device, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:songs) }
  end

  describe "validations" do
    it { should validate_presence_of(:user_agent) }
  end
end

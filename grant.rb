# frozen_string_literal: true

class Points::Grant < ApplicationRecord
  attr_accessor :points, :beneficiary

  include Taggable
  include Notifiable

  belongs_to :author, class_name: "User"
  belongs_to :reward_program_category
  belongs_to :organization
  has_many :points_changes, as: :reason, class_name: "Points::Change", dependent: :destroy
  has_one :post, as: :postable
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :points_grant_recipients, class_name: "Points::GrantRecipient"
  has_many :recipients, class_name: "User", through: :points_grant_recipients, source: :user

  validates_presence_of :points, :recipients, on: :create
  validates_presence_of :organization

  after_create :register_points_change_and_notify

  alias_attribute :content, :comment
  alias_attribute :name, :title
  delegate :sharing_type, to: :post

  mount_uploader :image, FeedImageUploader
  mount_uploader :attachment, NewsFeedUploader

  def title
    reward_program_category.present? ? reward_program_category.title : "Recognition"
  end

  def birthday_recognition?
    return false unless reward_program_category

    reward_program_category.milestone.birthday_milestone?
  end

  private

  def register_points_change_and_notify
    recipients.each do |user|
      reward_points = user.reward_points
      register_points_change(user)
      RecognitionsMailer.delay.recognition(self, user.id, reward_points)
    end

  end

  def register_points_change(user)
    points_changes.create!(
      points: points,
      expense: false,
      user: user,
      organization: organization,
    )
  end

  def notify(user)
    RecognitionsMailer.delay.recognition(self, user.id)
  end

  def is_author_hr?
    author.try(:hr?)
  end
end

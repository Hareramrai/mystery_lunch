# frozen_string_literal: true

class Lunch < ApplicationRecord
  acts_as_paranoid

  # validations
  validates :title, :lunch_date, presence: true
  validates :lunch_date, uniqueness: true

  # associations
  has_many :lunch_teams, dependent: :destroy

  # callbacks
  before_validation { self.lunch_date = lunch_date&.beginning_of_month }

  # scopes
  scope :latest, -> { order(lunch_date: :desc).first }
end

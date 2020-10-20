# frozen_string_literal: true

class LunchTeam < ApplicationRecord
  acts_as_paranoid

  # relations
  has_many :mystery_matches, dependent: :destroy
  has_many :employees, through: :mystery_matches

  belongs_to :lunch
end

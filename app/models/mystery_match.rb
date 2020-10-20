# frozen_string_literal: true

class MysteryMatch < ApplicationRecord
  acts_as_paranoid

  # relations
  belongs_to :employee, -> { with_deleted },
             class_name: "Employee",
             foreign_key: :user_id,
             inverse_of: :mystery_matches

  belongs_to :lunch_team

  has_many :members, through: :lunch_team, source: :employees
end

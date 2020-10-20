# frozen_string_literal: true

class Department < ApplicationRecord
  acts_as_paranoid

  # validations
  validates :name, presence: true, uniqueness: { caseinsensitive: true }

  # relations
  has_many :employees, dependent: :destroy

  belongs_to :manager, class_name: "Employee", optional: true

  # delegations

  delegate :name, to: :manager, prefix: true, allow_nil: true
end

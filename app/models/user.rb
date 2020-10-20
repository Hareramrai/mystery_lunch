# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_paranoid

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  has_one_attached :avatar

  # validations
  validates :first_name, :last_name, presence: true

  # delegations
  delegate :name, to: :department, prefix: true

  def name
    "#{first_name} #{last_name}"
  end
end

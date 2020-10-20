# frozen_string_literal: true

class Employee < User
  # attributes
  attribute :matched, :boolean

  # relations
  has_many :mystery_matches, foreign_key: :user_id, inverse_of: :employee
  has_many :recent_mystery_matches,
           -> {
             order(id: :desc).limit(3)
           }, class_name: "MysteryMatch",
              foreign_key: :user_id,
              inverse_of: :employee
  has_many :recent_mystery_match_members,
           through: :recent_mystery_matches, source: :members

  has_many :lunch_teams, through: :mystery_matches
  has_many :future_lunch_teams, -> {
    joins(:lunch)
      .where(
        lunches: { lunch_date: Time.zone.today.. }
      )
  }, through: :mystery_matches, source: :lunch_team

  belongs_to :department

  def recent_partners
    recent_mystery_match_members.uniq(&:id).reject { |member| member.id == id }
  end
end

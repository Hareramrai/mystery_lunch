# frozen_string_literal: true

class Mystery::CreateMatchesService < ApplicationService
  def initialize(lunch:, lunch_teams:)
    @lunch = lunch
    @lunch_teams = lunch_teams
  end

  # rubocop:disable Rails/SkipsModelValidations
  def call
    ActiveRecord::Base.transaction do
      mystery_matches = []
      now = Time.current

      lunch_teams.each do |lunch_team|
        team = lunch.lunch_teams.create!
        lunch_team.each do |team_member|
          mystery_matches << { user_id: team_member.id, lunch_team_id: team.id,
                               created_at: now, updated_at: now, }
        end
      end

      MysteryMatch.insert_all!(mystery_matches)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations

  private

    attr_reader :lunch, :lunch_teams
end

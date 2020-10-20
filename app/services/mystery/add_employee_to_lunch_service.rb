# frozen_string_literal: true

class Mystery::AddEmployeeToLunchService < ApplicationService
  def initialize(employee:, lunch:)
    @employee = employee
    @lunch = lunch
  end

  def call
    lunch.lunch_teams.each do |lunch_team|
      if can_accomodate_in_team?(lunch_team: lunch_team)
        lunch_team.mystery_matches.create!(user_id: employee.id)
        break
      end
    end
  end

  private

    attr_reader :employee, :lunch

    def can_accomodate_in_team?(lunch_team:)
      # ignore if already a 3 people myster lunch
      return false if lunch_team.employees.size > 2

      department_ids = lunch_team
                       .employees.collect(&:department_id) | [employee.department_id]

      # ignore if they don't have unique department
      return false if department_ids.size != 3

      true
    end
end

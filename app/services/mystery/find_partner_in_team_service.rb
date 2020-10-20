# frozen_string_literal: true

class Mystery::FindPartnerInTeamService < ApplicationService
  def initialize(employees:, lunch_teams:)
    @employees = employees
    @lunch_teams = lunch_teams
  end

  def call
    employees.each do |employee|
      accomodate_employee(employee: employee)
    end

    @lunch_teams
  end

  private

    attr_reader :employees, :lunch_teams

    def accomodate_employee(employee:)
      lunch_teams.each_with_index do |lunch_team, index|
        next unless can_accomodate_in_team?(employee: employee, lunch_team: lunch_team)

        @lunch_teams[index] = lunch_team << employee
        break
      end
    end

    def can_accomodate_in_team?(employee:, lunch_team:)
      return false if lunch_team.size > 2
      return false if (employee.recent_partners & lunch_team).present?

      if (lunch_team.collect(&:department_id) | [employee.department_id]).size != 3
        return false
      end

      true
    end
end

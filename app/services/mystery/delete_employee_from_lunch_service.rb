# frozen_string_literal: true

class Mystery::DeleteEmployeeFromLunchService < ApplicationService
  delegate :future_lunch_teams, to: :employee

  def initialize(employee:)
    @employee = employee
  end

  def call
    future_lunch_teams.each do |future_lunch_team|
      if future_lunch_team.employees.size == 3
        remove_me_from_from_the_lunch_team(lunch_team: future_lunch_team)
      else
        other_employee = other_employee_from_team(lunch_team: future_lunch_team)
        lunch = future_lunch_team.lunch

        future_lunch_team.really_destroy!

        Mystery::AddEmployeeToLunchService.call(
          employee: other_employee,
          lunch: lunch
        )
      end
    end

    employee.destroy
  end

  private

    attr_reader :employee, :lunch

    def remove_me_from_from_the_lunch_team(lunch_team:)
      lunch_team.mystery_matches.find_by(user_id: employee.id).really_destroy!
    end

    def other_employee_from_team(lunch_team:)
      lunch_team.employees.reject { |emp| emp.id == employee.id }.first
    end
end

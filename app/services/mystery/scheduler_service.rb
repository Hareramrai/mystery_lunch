# frozen_string_literal: true

class Mystery::SchedulerService < ApplicationService
  def initialize(lunch:)
    @lunch = lunch
    @lunch_teams = []
    @failed_to_find_match_employees = []
  end

  def call
    setup
    find_matchings
    handle_failed_to_match_employees
  end

  private

    attr_reader :lunch, :employees, :groupped_employees

    def setup
      load_employees_with_department_and_recent_match_members
      groupped_employees_by_department
    end

    def find_matchings
      employees.each do |employee|
        next if employee.matched

        potential_partners = unmatched_employees_from_other_departments(
          employee: employee
        )

        matched_employee = Mystery::FindPartnerService.call(
          employee: employee,
          potential_partners: potential_partners
        )
        update_match_results(employee: employee, matched_employee: matched_employee)
      end
    end

    def load_employees_with_department_and_recent_match_members
      @employees = Employee.includes(:department, :recent_mystery_match_members).shuffle
    end

    def groupped_employees_by_department
      @groupped_employees = employees.group_by(&:department_name)
    end

    def unmatched_employees_from_other_departments(employee:)
      @groupped_employees
        .except(employee.department_name)
        .values.flatten - @lunch_teams.flatten
    end

    def update_match_results(employee:, matched_employee:)
      if matched_employee
        matched_employee.matched = true
        @lunch_teams << [employee, matched_employee]
      else
        @failed_to_find_match_employees << employee
      end
    end

    def handle_failed_to_match_employees
      @lunch_teams = Mystery::FindPartnerInTeamService
                     .call(lunch_teams: @lunch_teams,
                           employees: @failed_to_find_match_employees)

      Mystery::CreateMatchesService.call(lunch: lunch, lunch_teams: @lunch_teams)
    end
end

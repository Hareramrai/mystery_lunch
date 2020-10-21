# frozen_string_literal: true

class ExchangeEmployeePartnerService < ApplicationService
  def initialize(current_employee:, employee:)
    @current_employee = current_employee
    @employee = employee
    @lunch = Lunch.latest
  end

  def call
    return unless check_for_matching?

    exchange_all_employees
  end

  private

    attr_reader :current_employee, :employee, :lunch

    # rubocop:disable Metrics/AbcSize
    def check_for_matching?
      return false if employee.department_id == current_employee.department_id
      if (employee.recent_partners & current_employee.recent_partners).present?
        return false
      end

      if current_employee_other_partner.department_id ==
         employee_other_partner.department_id
        return false
      end

      if (current_employee_other_partner.recent_partners &
          employee_other_partner.recent_partners).present?
        false
      end

      true
    end
    # rubocop:enable Metrics/AbcSize

    def latest_team_by_employee(employee:)
      lunch.lunch_teams
           .includes(:employees)
           .joins(:mystery_matches)
           .find_by({ mystery_matches: { user_id: employee.id } })
    end

    # TODO: to check for more than partner, for now will check for one partner
    def current_employee_other_partner
      @current_employee_other_partner ||= latest_team_by_employee(
        employee: current_employee
      ).employees.reject do |member|
        member.id == current_employee.id
      end.first
    end

    # TODO: to check for more than partner
    def employee_other_partner
      @employee_other_partner ||= latest_team_by_employee(
        employee: employee
      ).employees.reject do |member|
        member.id == employee.id
      end.first
    end

    def exchange_all_employees
      ActiveRecord::Base.transaction do
        delete_previous_matching
        create_new_matching
      end
    end

    def delete_previous_matching
      latest_team_by_employee(employee: current_employee).really_destroy!
      latest_team_by_employee(employee: employee).really_destroy!
    end

    def create_new_matching
      create_new_matching_for(employee1: current_employee,
                              employee2: employee)

      create_new_matching_for(employee1: current_employee_other_partner,
                              employee2: employee_other_partner)
    end

    def create_new_matching_for(employee1:, employee2:)
      lunch_team = lunch.lunch_teams.create
      lunch_team.mystery_matches.create!(user_id: employee1.id)
      lunch_team.mystery_matches.create!(user_id: employee2.id)
    end
end

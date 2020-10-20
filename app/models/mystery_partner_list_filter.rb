# frozen_string_literal: true

class MysteryPartnerListFilter
  attr_reader :lunch, :department_id

  def initialize(filter_params:)
    @lunch = Lunch.find_by(id: filter_params[:lunch_id]) || Lunch.latest
    @department_id = filter_params[:department_id]
  end

  def department
    @department ||= filterable_departments.find_by(id: department_id)
  end

  def department_selected?
    department.present?
  end

  def filterable_departments
    @filterable_departments ||= Department.all
  end

  def filterable_lunches
    @filterable_lunches ||= Lunch.all
  end

  def filtered_results
    lunch_teams = @lunch.lunch_teams
    if department_id
      lunch_team_ids = lunch_teams.joins(:employees)
                                  .where(users: { department_id: department_id }).ids

      lunch_teams = LunchTeam.where(id: lunch_team_ids)
    end

    lunch_teams.includes(:employees)
  end

  def to_params(department_id: nil, lunch_id: nil)
    params = {}
    params[:department_id] = department_id || @department_id
    params[:lunch_id] = lunch_id || lunch.id
    params
  end
end

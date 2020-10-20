# frozen_string_literal: true

class Mystery::FindPartnerService < ApplicationService
  def initialize(employee:, potential_partners:)
    @employee = employee
    @potential_partners = potential_partners
  end

  def call
    (potential_partners - my_recent_partners).sample
  end

  private

    attr_reader :employee, :potential_partners

    def my_recent_partners
      employee.recent_partners
    end
end

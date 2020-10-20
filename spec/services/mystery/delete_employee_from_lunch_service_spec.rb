# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mystery::DeleteEmployeeFromLunchService do
  describe ".call" do
    include_context "sample employees and departments data with matched recently"

    before { brad.update(department: sales_department) }

    it "deletes from the lunch & try to match other employee" do
      described_class.call(employee: oliver)
      lunch.reload

      expect(lunch.lunch_teams.size).to eq(1)
      employees = lunch.lunch_teams.first.employees
      # it will create a 3 member lunch team
      expect(employees).to contain_exactly(henry, brad, timo)
    end
  end
end

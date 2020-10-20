# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mystery::AddEmployeeToLunchService do
  describe ".call" do
    include_context "sample employees and departments data with matched recently"

    let(:new_employee) { create(:employee) }

    it "creates a match of 3 people mystery lunch" do
      expect(new_employee.mystery_matches.reload).to be_blank

      described_class.call(employee: new_employee, lunch: lunch)

      expect(new_employee.recent_mystery_match_members.size).to eq(3)
    end
  end
end

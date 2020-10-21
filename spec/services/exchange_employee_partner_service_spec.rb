# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExchangeEmployeePartnerService do
  let!(:hr_department) { create(:department, name: "HR") }
  let!(:development_department) { create(:department, name: "Development") }
  let!(:sales_department) { create(:department, name: "Sales") }
  let!(:support_department) { create(:department, name: "Support") }

  let(:oliver) { create(:employee, first_name: "Oliver", department: hr_department) }
  let(:henry) { create(:employee, first_name: "Henry", department: development_department) }

  let(:james) { create(:employee, first_name: "James", department: sales_department) }
  let(:brad) { create(:employee, first_name: "Brad", department: support_department) }

  let(:lunch) { create(:lunch, lunch_date: Time.zone.today + 1.month) }

  describe ".call" do
    before do
      lunch_team = lunch.lunch_teams.create!
      lunch_team.mystery_matches.create!(user_id: oliver.id)
      lunch_team.mystery_matches.create!(user_id: henry.id)

      lunch_team = lunch.lunch_teams.create!
      lunch_team.mystery_matches.create!(user_id: james.id)
      lunch_team.mystery_matches.create!(user_id: brad.id)
    end

    it "exchanges the partners of current_employee and employee" do
      expect(oliver.recent_partners).to eq([henry])
      expect(brad.recent_partners).to eq([james])

      described_class.call(current_employee: oliver, employee: brad)

      expect(oliver.reload.recent_partners).to eq([brad])
      expect(james.reload.recent_partners).to eq([henry])
    end
  end
end

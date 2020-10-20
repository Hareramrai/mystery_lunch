# frozen_string_literal: true

RSpec.shared_context "sample employees and departments data" do
  let!(:hr_department) { create(:department, name: "HR") }
  let!(:development_department) { create(:department, name: "Development") }
  let!(:sales_department) { create(:department, name: "Sales") }

  let!(:oliver) { create(:employee, first_name: "Oliver", department: hr_department) }
  let!(:henry) { create(:employee, first_name: "Henry", department: hr_department) }

  let!(:james) { create(:employee, first_name: "James", department: sales_department) }

  let!(:brad) { create(:employee, first_name: "Brad", department: development_department) }
  let!(:timo) { create(:employee, first_name: "Timo", department: development_department) }
end

RSpec.shared_context "sample employees and departments data with matched recently" do
  let(:lunch) { create(:lunch, lunch_date: Time.zone.today + 1.month) }

  let!(:hr_department) { create(:department, name: "HR") }
  let!(:development_department) { create(:department, name: "Development") }
  let!(:sales_department) { create(:department, name: "Sales") }

  let!(:oliver) { create(:employee, first_name: "Oliver", department: hr_department) }
  let!(:henry) { create(:employee, first_name: "Henry", department: hr_department) }

  let!(:brad) { create(:employee, first_name: "Brad", department: development_department) }
  let!(:timo) { create(:employee, first_name: "Timo", department: development_department) }

  let!(:team1) { create(:lunch_team, lunch: lunch) }
  let!(:team2) { create(:lunch_team, lunch: lunch) }

  let!(:mystery_match1) { create(:mystery_match, user_id: oliver.id, lunch_team: team1) }
  let!(:mystery_match2) { create(:mystery_match, user_id: brad.id, lunch_team: team1) }

  let!(:mystery_match3) { create(:mystery_match, user_id: henry.id, lunch_team: team2) }
  let!(:mystery_match4) { create(:mystery_match, user_id: timo.id, lunch_team: team2) }
end

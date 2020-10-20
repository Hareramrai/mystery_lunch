# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mystery::SchedulerService do
  describe ".call" do
    context "when there is no past lunch" do
      include_context "sample employees and departments data"
      let(:lunch) { create(:lunch, lunch_date: Time.zone.today) }

      it "schedules partner for each of the employees" do
        expect(lunch.lunch_teams).to be_blank

        described_class.call(lunch: lunch)

        # every employee will be macthed
        expect(oliver.mystery_matches).to be_present
        expect(henry.mystery_matches).to be_present
        expect(james.mystery_matches).to be_present
        expect(brad.mystery_matches).to be_present
        expect(timo.mystery_matches).to be_present

        # As the number of employees is odd,
        # so  we will have one team with three employees
        # other team with two employees
        number_of_employees_in_each_team = lunch.lunch_teams.map { |team| team.employees.size }.sort
        expect(number_of_employees_in_each_team).to eq([2, 3])
      end
    end

    context "last three recent partner should not matched" do
      include_context "sample employees and departments data with matched recently"

      let(:lunch) { create(:lunch, lunch_date: Time.zone.today + 1.month) }

      it "last partner should not repeat unless three month" do
        expect(oliver.recent_partners).to eq([brad])
        expect(henry.recent_partners).to eq([timo])

        described_class.call(lunch: lunch)

        oliver.reload
        henry.reload
        # can't matched last partner again
        expect(oliver.recent_partners).to_not contain_exactly(brad, brad)
        # would go with another partner
        expect(henry.recent_partners).to contain_exactly(timo, brad)
      end
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe Employee, type: :model do
  it_behaves_like "deleted record not visible"

  describe "relationships" do
    it { is_expected.to have_many(:mystery_matches) }
    it { is_expected.to have_many(:lunch_teams) }
    it { is_expected.to belong_to(:department) }
  end

  describe "mystery matches related methods" do
    let(:employee1) { create(:employee) }
    let(:employee2) { create(:employee) }

    let(:lunch) { create(:lunch, :future) }
    let(:lunch_team) { create(:lunch_team, lunch: lunch) }

    before do
      create(:mystery_match, user_id: employee1.id, lunch_team: lunch_team)
      create(:mystery_match, user_id: employee2.id, lunch_team: lunch_team)
    end

    describe "#recent_mystery_matches" do
      it "returns only last three matches" do
        expect(employee1.recent_mystery_matches)
          .to eq(employee1.mystery_matches.order(id: :desc).limit(3))
      end
    end

    describe "#recent_partners" do
      it "returns the other employees who joined in lunch" do
        expect(employee1.recent_partners).to eq([employee2])
      end
    end

    describe "#future_lunch_teams" do
      it "returns only the future lunch_team" do
        expect(employee1.future_lunch_teams).to eq([lunch_team])
      end
    end
  end
end

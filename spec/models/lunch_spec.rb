# frozen_string_literal: true

require "rails_helper"

RSpec.describe Lunch, type: :model do
  it_behaves_like "deleted record not visible"

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:lunch_date) }
  end

  describe "relationships" do
    it { is_expected.to have_many(:lunch_teams) }
  end

  describe ".latest" do
    let!(:lunch1) { create(:lunch, lunch_date: Time.zone.yesterday) }
    let!(:lunch2) { create(:lunch, lunch_date: Time.zone.today + 1.month) }

    it "returns the latest lunch" do
      expect(Lunch.latest).to eq(lunch2)
    end
  end
end

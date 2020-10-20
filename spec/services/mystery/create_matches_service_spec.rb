# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mystery::CreateMatchesService do
  describe ".call" do
    include_context "sample employees and departments data"

    let(:lunch) { create(:lunch, lunch_date: Time.zone.today) }

    it "creates the matches & teams for the given teams" do
      expect(henry.mystery_matches).to be_blank
      expect(brad.mystery_matches).to be_blank
      expect(lunch.lunch_teams).to be_blank

      described_class.call(lunch: lunch, lunch_teams: [[henry, brad]])

      expect(henry.mystery_matches.reload).to be_present
      expect(brad.mystery_matches.reload).to be_present
      expect(lunch.lunch_teams.reload).to be_present
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe MysteryMatch, type: :model do
  describe "relationships" do
    it { is_expected.to have_many(:members) }
    it { is_expected.to belong_to(:employee) }
    it { is_expected.to belong_to(:lunch_team) }
  end
end

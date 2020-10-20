# frozen_string_literal: true

require "rails_helper"

RSpec.describe LunchTeam, type: :model do
  it_behaves_like "deleted record not visible"

  describe "relationships" do
    it { is_expected.to have_many(:mystery_matches) }
    it { is_expected.to have_many(:employees) }
    it { is_expected.to belong_to(:lunch) }
  end
end

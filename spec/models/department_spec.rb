# frozen_string_literal: true

require "rails_helper"

RSpec.describe Department, type: :model do
  it_behaves_like "deleted record not visible"

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }

    context "uniqueness" do
      subject { build(:department) }
      it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    end
  end

  describe "relationships" do
    it { is_expected.to have_many(:employees) }
    it { is_expected.to belong_to(:manager).optional }
  end
end

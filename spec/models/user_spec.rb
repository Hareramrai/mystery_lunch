# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  it_behaves_like "deleted record not visible"

  describe "validations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }

    context "uniqueness" do
      subject { build(:user) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end
  end

  describe "relationships" do
    it { is_expected.to have_one_attached(:avatar) }
  end

  describe "#name" do
    let(:user) { build(:user) }

    it "returns joins of first name and last name" do
      expect(user.name).to eq("#{user.first_name} #{user.last_name}")
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe SampleDataLoaderService do
  describe ".call" do
    it "creates sample data for departments, employees and admin" do
      expect(Department).not_to be_any
      expect(Employee).not_to be_any
      expect(Admin).not_to be_any

      described_class.call

      expect(Department).to be_any
      expect(Employee).to be_any
      expect(Admin).to be_any
    end
  end
end

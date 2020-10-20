# frozen_string_literal: true

require "rails_helper"

RSpec.describe MysteryPartnerListFilter, type: :model do
  include_context "sample employees and departments data with matched recently"
  let(:filter_params) { { lunch_id: nil, department_id: nil } }

  subject { described_class.new(filter_params: filter_params) }

  describe "#filterable_departments" do
    it "returns all departments" do
      expect(subject.filterable_departments).to eq(Department.all)
    end
  end

  describe "#filterable_lunches" do
    it "returns all lunches" do
      expect(subject.filterable_lunches).to eq(Lunch.all)
    end
  end

  context "filterings" do
    let(:filter_params) { { department_id: hr_department.id, lunch_id: lunch.id } }

    describe "#filtered_results" do
      context "when department has matches" do
        it "returns all filtered_results" do
          expect(subject.filtered_results).to contain_exactly(team1, team2)
        end
      end

      context "when department has matches" do
        let(:filter_params) { { department_id: sales_department.id, lunch_id: lunch.id } }

        it "returns blank filtered_results" do
          expect(subject.filtered_results).to be_blank
        end
      end
    end

    describe "#to_params" do
      it "returns all params as hash" do
        expect(subject.to_params).to eq(filter_params)
      end
    end

    describe "#department_selected?" do
      it "returns true when selected" do
        expect(subject.department_selected?).to be_truthy
      end
    end
  end
end

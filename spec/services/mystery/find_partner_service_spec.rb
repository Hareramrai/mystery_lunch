# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mystery::FindPartnerService do
  describe ".call" do
    include_context "sample employees and departments data with matched recently"

    context "when passing potential partner as recent one" do
      it "returns nil" do
        result = described_class.call(employee: oliver, potential_partners: [brad])
        expect(result).to be_nil
      end
    end

    context "when passing potential partners as not recent one" do
      it "returns the a next partner" do
        result = described_class.call(employee: oliver, potential_partners: [timo])
        expect(result).to eq(timo)
      end
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/mystery_partners", type: :request do
  include_context "sample employees and departments data with matched recently"

  describe "GET /index" do
    it "renders a successful response" do
      get root_url
      expect(response).to be_successful
    end
  end
end

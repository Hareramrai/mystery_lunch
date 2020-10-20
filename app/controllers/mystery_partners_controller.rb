# frozen_string_literal: true

class MysteryPartnersController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @partner_list_filter = MysteryPartnerListFilter.new(filter_params: filter_params)
  end

  private

    def filter_params
      params.permit(:lunch_id, :department_id)
    end
end

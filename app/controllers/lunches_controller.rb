# frozen_string_literal: true

# This could be removed, I have added it becuase to see the mystery
# partner assignments via UI only & no need wait for cron to run it
class LunchesController < ApplicationController
  def index
    @lunches = Lunch.page params[:page]
  end

  def new
    @lunch = Lunch.new
  end

  def create
    @lunch = Lunch.new(lunch_params)
    if @lunch.save
      # create matches for this lunch
      CreateMatchesJob.perform_later(@lunch.id)

      redirect_to :lunches, notice: "Lunch was successfully created."
    else
      render :new
    end
  end

  private

    def lunch_params
      params.require(:lunch).permit(:title, :lunch_date)
    end
end

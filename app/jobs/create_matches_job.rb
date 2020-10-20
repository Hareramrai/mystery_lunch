# frozen_string_literal: true

class CreateMatchesJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  def perform(lunch_id)
    lunch = Lunch.find(lunch_id)
    Mystery::SchedulerService.call(lunch: lunch)
  end
end

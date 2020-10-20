# frozen_string_literal: true

namespace :cron do
  desc "Create monthly mystery lunch matches"
  task create_monthly_mystery_lunch_matches: :environment do
    lunch = Lunch.create!(lunch_date: Time.zone.today,
                          title: "Lunch for #{Time.zone.today.strftime('%m, %y')}")

    Mystery::SchedulerService.call(lunch: lunch)
  end
end

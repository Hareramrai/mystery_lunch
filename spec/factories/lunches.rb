# frozen_string_literal: true

FactoryBot.define do
  factory :lunch do
    sequence(:lunch_date) { |number| Time.zone.today - number.months }
    title { "Lunch for #{lunch_date.strftime('%m, %y')}" }

    trait :future do
      lunch_date { Faker::Date.unique.between(from: Time.zone.today, to: 20.years.from_now) }
    end
  end
end

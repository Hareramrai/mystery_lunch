# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: "User" do
    first_name  { Faker::Name.unique.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.safe_email(name: first_name) }
    password { "mypassword" }
    type { "User" }
  end

  factory :employee, parent: :user, class: "Employee" do
    department
    type { "Employee" }

    trait :with_existing_matches do
      after :create do |user|
        create_list :mystery_match, 5, user_id: user.id
      end
    end
  end
end

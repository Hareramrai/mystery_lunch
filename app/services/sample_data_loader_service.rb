# frozen_string_literal: true

class SampleDataLoaderService < ApplicationService
  DEPARTMENTS = %w[operations sales marketing risk management finance HR development
                   data].freeze

  def call
    return if Department.any?

    ActiveRecord::Base.transaction do
      DEPARTMENTS.map do |name|
        department = Department.create!(name: name)
        number_of_employees.times do
          create_employee(department: department)
        end
        create_manager(department: department)
      end

      create_admin
    end
  end

  private

    def number_of_employees
      Rails.application.secrets.number_of_employees.to_i
    end

    def defautl_password
      Rails.application.secrets.defautl_password
    end

    def create_employee(department:)
      Employee.create! user_params(department: department)
    end

    def create_admin
      Admin.create!(first_name: "Admin", last_name: "Tyler", email: "admin@example.com",
                    password: defautl_password)
    end

    def create_manager(department:)
      manager = create_employee(department: department)
      department.update(manager: manager)
    end

    def user_params(department:)
      first_name = Faker::Name.unique.first_name
      {
        first_name: first_name,
        last_name: Faker::Name.unique.last_name,
        email: Faker::Internet.safe_email(name: first_name), # email based on first_name
        password: defautl_password,
        department: department,
      }
    end
end

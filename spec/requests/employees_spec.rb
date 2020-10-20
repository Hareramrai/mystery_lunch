# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/employees", type: :request do
  let(:department) { create(:department) }
  let!(:lunch) { create(:lunch, lunch_date: Time.zone.today + 1.month) }
  let!(:employee) { create(:employee) }
  let!(:employee1) { create(:employee) }

  let(:valid_attributes) do
    attributes_for(:employee, department_id: department.id)
  end

  let(:invalid_attributes) do
    {
      first_name: "",
    }
  end

  before { sign_in employee }

  describe "GET /index" do
    it "renders a successful response" do
      get employees_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get employee_url(employee)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_employee_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      get edit_employee_url(employee)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    before { Mystery::SchedulerService.call(lunch: lunch) }

    context "with valid parameters" do
      it "creates a new Employee with mystery_matches" do
        expect do
          post employees_url, params: { employee: valid_attributes }
        end.to change(Employee, :count).by(1)

        expect(Employee.last.mystery_matches).to be_present
      end

      it "redirects to the created employee" do
        post employees_url, params: { employee: valid_attributes }
        expect(response).to redirect_to(employee_url(Employee.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Employee" do
        expect do
          post employees_url, params: { employee: invalid_attributes }
        end.to change(Employee, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post employees_url, params: { employee: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        { first_name: "Test Updated" }
      end

      it "updates the requested employee" do
        patch employee_url(employee), params: { employee: new_attributes }
        employee.reload
        expect(employee.first_name).to eq("Test Updated")
      end

      it "redirects to the employee" do
        patch employee_url(employee), params: { employee: new_attributes }
        employee.reload
        expect(response).to redirect_to(employee_url(employee))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        patch employee_url(employee), params: { employee: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    before { Mystery::SchedulerService.call(lunch: lunch) }

    it "destroys the requested department & cleans the mystery_matches" do
      expect do
        delete employee_url(employee)
      end.to change(Employee, :count).by(-1)

      expect(employee.mystery_matches).to be_blank
    end

    it "redirects to the departments list" do
      delete employee_url(employee)
      expect(response).to redirect_to(employees_url)
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/departments", type: :request do
  let!(:employee) { create(:employee) }
  let(:valid_attributes) do
    {
      name: "Test Department",
      manager_id: employee.id,
    }
  end

  let(:invalid_attributes) do
    {
      name: "",
    }
  end

  before { sign_in employee }

  describe "GET /index" do
    it "renders a successful response" do
      Department.create! valid_attributes
      get departments_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      department = Department.create! valid_attributes
      get department_url(department)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_department_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      department = Department.create! valid_attributes
      get edit_department_url(department)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Department" do
        expect do
          post departments_url, params: { department: valid_attributes }
        end.to change(Department, :count).by(1)
      end

      it "redirects to the created department" do
        post departments_url, params: { department: valid_attributes }
        expect(response).to redirect_to(department_url(Department.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Department" do
        expect do
          post departments_url, params: { department: invalid_attributes }
        end.to change(Department, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post departments_url, params: { department: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        { name: "Test Department Updated" }
      end

      it "updates the requested department" do
        department = Department.create! valid_attributes
        patch department_url(department), params: { department: new_attributes }
        department.reload
        expect(department.name).to eq("Test Department Updated")
      end

      it "redirects to the department" do
        department = Department.create! valid_attributes
        patch department_url(department), params: { department: new_attributes }
        department.reload
        expect(response).to redirect_to(department_url(department))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        department = Department.create! valid_attributes
        patch department_url(department), params: { department: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested department" do
      department = Department.create! valid_attributes
      expect do
        delete department_url(department)
      end.to change(Department, :count).by(-1)
    end

    it "redirects to the departments list" do
      department = Department.create! valid_attributes
      delete department_url(department)
      expect(response).to redirect_to(departments_url)
    end
  end
end

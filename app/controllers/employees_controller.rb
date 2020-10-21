# frozen_string_literal: true

class EmployeesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_employee, only: [:edit, :update, :destroy, :exchange]

  def index
    @employees = Employee.page params[:page]
  end

  def show
    @employee = Employee.includes(lunch_teams: :employees).find(params[:id])
  end

  def new
    @employee = Employee.new
  end

  def edit
  end

  def create
    @employee = Employee.new(employee_params)

    if @employee.save
      Mystery::AddEmployeeToLunchService.call(
        employee: @employee,
        lunch: Lunch.includes(lunch_teams: :employees).latest
      )

      redirect_to @employee, notice: "Employee was successfully created."
    else
      render :new
    end
  end

  def update
    if @employee.update(employee_params)
      redirect_to @employee, notice: "Employee was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    Mystery::DeleteEmployeeFromLunchService.call(employee: @employee)

    redirect_to employees_url, notice: "Employee was successfully destroyed."
  end

  def exchange
    exchange_result = ExchangeEmployeePartnerService.call(
      current_employee: current_user,
      employee: @employee
    )

    if exchange_result
      redirect_to @employee, notice: "Exchange was successfully."
    else
      redirect_to @employee, alert: "Exchange wasn't allowed."
    end
  end

  private

    def set_employee
      @employee = Employee.find(params[:id])
    end

    def employee_params
      params.require(:employee).permit(:email, :first_name, :last_name, :password,
                                       :department_id, :avatar)
    end
end

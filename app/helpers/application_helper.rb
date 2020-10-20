# frozen_string_literal: true

module ApplicationHelper
  def avatar_url(employee)
    if employee.avatar.attached?
      polymorphic_url(employee.avatar)
    else
      asset_url("user.png")
    end
  end
end

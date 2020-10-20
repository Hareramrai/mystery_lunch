# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
  }

  resources :departments
  resources :mystery_partners, only: [:index]
  resources :lunches, only: [:index, :new, :create]
  resources :employees

  root to: "mystery_partners#index"
end

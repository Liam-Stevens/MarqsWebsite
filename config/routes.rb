Rails.application.routes.draw do
  # Nest submissions within assignments
  # e.g. /assignment/1234/submission/22
  root :index

  shallow do
    resources :assignments do
      resources :submissions
    end
  end

  resources :courses
  resources :markers
  resources :student
end

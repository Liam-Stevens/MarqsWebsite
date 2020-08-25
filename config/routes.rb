Rails.application.routes.draw do
  # Nest submissions within assignments
  # e.g. /assignment/1234/submissions   -> list all submissions for assignment
  # e.g. /submissions/22                -> list specific submission
  scope shallow_prefix: 'submission' do
    resources :assignments do
      resources :submissions, shallow: true
    end
  end

  resources :courses
  resources :markers
  resources :student
end

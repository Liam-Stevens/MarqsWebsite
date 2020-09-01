Rails.application.routes.draw do
  # Nest submissions within assignments
  # e.g. /assignment/1234/submissions   -> list all submissions for assignment
  # e.g. /submissions/22                -> list specific submission
  shallow do
    resources :assignments do
      resources :submissions, shallow: true
    end
  end

  # Nest comments within submissions
  # e.g. /submission/1234/comments   -> list all comments for submission
  # e.g. /comments/22                -> list specific comment
  shallow do
    resources :submissions do
      resources :comments, shallow: true
    end
  end

  root 'login#index'
  resources :courses
  resources :markers
  resources :login
  resources :students do
    get "course"
end

end

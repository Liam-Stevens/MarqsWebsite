Rails.application.routes.draw do
  # Nest submissions within assignments
  # e.g. /assignment/1234/submissions   -> list all submissions for assignment
  # e.g. /submissions/22                -> list specific submission
  shallow do
    resources :assignments do
      resources :submissions, shallow: true
      post '/submissions/import' , to: 'submissions#import'
    end
  end

  root 'homepage#index'
  resources :login

    resources :students do
        resources :courses do
            resources :assignments do
                resources :submissions
            end
        end
    end

    resources :markers do
        resources :courses do
            resources :assignments do
                resources :submissions, shallow: true
            end
        end
    end
end

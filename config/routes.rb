Rails.application.routes.draw do
    root 'homepage#index'
    resources :login

    resources :students
    resources :markers

    resources :courses do
        resources :assignments do
            resources :submissions do
                post 'import'
                resources :comments, shallow: true
            end
        end
    end

end

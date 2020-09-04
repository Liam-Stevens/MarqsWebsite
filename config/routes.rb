Rails.application.routes.draw do
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
              resources :submissions do
                    post 'import'
                    resources :comments, shallow: true
                end
            end
        end
    end
end

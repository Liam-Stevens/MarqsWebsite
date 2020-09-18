Rails.application.routes.draw do
    root 'homepage#index'
    resources :login

    resources :students
    resources :markers

    resources :courses do 
        get 'marker', to: 'courses#show_marker'
        resources :assignments do
            resources :submissions do
                post 'import'
                get 'export'
                resources :comments, shallow: true
            end
        end
    end

end

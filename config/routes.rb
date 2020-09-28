Rails.application.routes.draw do
    root 'homepage#index'
    resources :login

    resources :students
    resources :markers

    resources :courses do 
        get 'marker', to: 'courses#show_marker'
    end
    resources :assignments do
        post 'import'
        get 'export'
    end
    resources :submissions do
        resources :comments, shallow: true
    end

end

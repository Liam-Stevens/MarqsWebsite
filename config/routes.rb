Rails.application.routes.draw do
    root 'homepage#index'
    resources :login, only: [:index, :show]

    resources :admin
    resources :students, only: [:show]
    resources :markers, only: [:show]

    resources :courses, only: [:show] do
        get 'marker', to: 'courses#show_marker'
        get 'failing', to: 'courses#show_failing'
        get 'summary'
    end

    resources :assignments, only: [:show] do
        post 'import'
        get 'export'
        get 'summary'
    end

    resources :submissions, only: [:show, :edit, :update] do
        resources :comments, only: [:create, :new, :edit, :update, :destroy], shallow: true
    end
end

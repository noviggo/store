Rails.application.routes.draw do

  # Sessions
  get 'login', to: 'sessions#new', as: 'login'
  post 'sessions', to: 'sessions#create', as: 'sessions'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  resources :password_resets, only: [:new, :create, :edit, :update]

  constraints AdminSubdomain do
    resources :accounts
  end

  constraints AccountSubdomain do
    # Launchpad
    get '/launchpad', to: 'launchpad#index', as: 'launchpad'

    # Profiles
    get 'profile', to: 'profiles#edit', as: 'profile'
    patch 'profile', to: 'profiles#update'

    # Resorces
    resources :cities
    resources :commodities, controller: :items, except: :index
    resources :commodities, only: :index
    resources :customers
    resources :feedbacks, only: [:index, :show, :edit, :update]
    resources :items
    resources :providers
    resources :services
    resources :states
    resources :users
    resources :warehouses

    resources :books, only: [] do
      resources :invoices, shallow: true
      resources :purchases, shallow: true
      resources :receipts, shallow: true
    end

    resources :organizations do
      resources :books, except: [:new], shallow: true do
        constraints flow: /income|outcome/ do
          get ':flow', to: 'books#new', as: '', on: :new, defaults: { flow: 'income' }
        end
      end
    end

    namespace :reports do
      get 'birthdays', to: 'birthdays#index', as: :birthdays
      get 'feedbacks', to: 'feedbacks#index', as: :feedbacks

      get 'commodities/:voucher',
        to:          'commodities#index',
        as:          :commodities,
        defaults:    { voucher: 'receipt' },
        constraints: { voucher: /receipt|invoice/ }
    end
  end

  root 'sessions#new'
end

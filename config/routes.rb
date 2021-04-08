require 'sidekiq/web'
require 'sidekiq/cron/web'

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  mount Sidekiq::Web => '/sidekiq'

  get '/healthz', to: proc { [200, {}, ['ok']] }

  resources :product, path: 'products'
  resources :location, path: 'locations'
  # resource :stock, path: 'stocks', only: %i[index show]

  get '/stocks', to: 'stock#index', as: :stock_index
  get '/stocks/:id', to: 'stock#show', as: :stock

end

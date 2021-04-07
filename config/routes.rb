Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/healthz', to: proc { [200, {}, ['ok']] }

  resources :product, path: 'products'
  resources :location, path: 'locations'

end

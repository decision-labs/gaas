Gaas::Application.routes.draw do
  devise_for :users
  devise_scope :user do
    get "sign_in", :to => "devise/sessions#new"
    get "sign_up", :to => "devise/registrations#new"
    delete "sign_out", :to => "devise/registrations#destroy"
  end
    
  root :to => "home#index"

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      # put route
       match '/vector_add' => 'vector_add#perform', via: :post
    end
  end

end

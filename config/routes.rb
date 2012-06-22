Gaas::Application.routes.draw do
  devise_for :users

  root :to => "home#index"

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      # put route
       match '/vector_add' => 'vector_add#perform', via: :post
    end
  end

end

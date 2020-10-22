Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do

      namespace :items do
        get '/:id/merchants', to: 'merchants#show'
      end

      namespace :merchants do
        get '/:id/items', to: 'items#index'
      end

      resources :items, except: [:new, :edit]
      resources :merchants, except: [:new, :edit]
    end
  end
end

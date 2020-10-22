Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do

      resources :items, except: [:new, :edit] do
        # get '/merchants', to: 'items/merchants#index'
      end
      namespace :merchants do
        get '/:id/items', to: 'items#index'
      end

      resources :merchants, except: [:new, :edit]
    end
  end
end

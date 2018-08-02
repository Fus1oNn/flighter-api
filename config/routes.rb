Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  namespace :api do
    resource :session, only: [:create, :destroy]
    resources :users, except: [:new, :edit]
    resources :companies, except: [:new, :edit]
    resources :bookings, except: [:new, :edit]
    resources :flights, except: [:new, :edit]
  end
  get '/world-cup', to: 'worldcup#index'
  get '/', to: redirect('/admin')
end

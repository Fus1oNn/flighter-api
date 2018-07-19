Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  get '/world-cup', to: 'worldcup#index'
  get '/', to: redirect('/admin')
end

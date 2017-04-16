Rails.application.routes.draw do
  root 'base#index'
  # не RESTful, но как задании сказано - так и делаем
  resource :admin, controller: 'news', only: [:show, :create, :update]
end

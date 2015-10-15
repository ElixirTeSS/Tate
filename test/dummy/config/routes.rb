Rails.application.routes.draw do
  resources :books
  mount Tate::Engine => "/tate"
end

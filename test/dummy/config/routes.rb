Rails.application.routes.draw do
  resource :books
  mount Tate::Engine => "/tate"
end

Rails.application.routes.draw do
  resources :movies
  root to: redirect("/movies")
  get "up" => "rails/health#show", as: :rails_health_check
end

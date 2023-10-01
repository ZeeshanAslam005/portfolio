Rails.application.routes.draw do
  resources :resumes, only: %i[index]
  get '/contact' => "resumes#contact", :as => :contact

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "resumes#index"
end

Rails.application.routes.draw do
  resources :songs
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: "static_pages#home"
	get 'privacy', to: 'static_pages#privacy_policy'
	post 'contact_mail', to: 'static_pages#contact_mail'
	get 'contact', to: 'static_pages#contact'
	get 'terms', to: 'static_pages#terms_of_use'
	get 'copyright', to: 'static_pages#copyright_claims'
  get 'search', to: 'search#get'
  post 'search', to: 'search#post'
  get 'download', to: 'download#get'
end

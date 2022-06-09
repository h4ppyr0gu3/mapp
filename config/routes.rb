# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :songs
  devise_for :users

  root to: 'static_pages#home'
  get 'privacy', to: 'static_pages#privacy_policy'
  post 'contact_mail', to: 'static_pages#contact_mail'
  get 'contact', to: 'static_pages#contact'
  get 'terms', to: 'static_pages#terms_of_use'
  get 'copyright', to: 'static_pages#copyright_claims'
  get 'search', to: 'search#get'
  post 'search', to: 'search#post'
  get 'download', to: 'download#get'
  get 'update_download', to: 'download#update_download'
  get 'user_songs', to: 'songs#user_index'
  post 'remove', to: 'playlist#remove'
  post 'add', to: 'playlist#add'
  get 'download_all', to: 'download#download_all'
  get 'profile', to: 'profiles#show'
  delete 'wipe_device', to: 'devices#wipe_device'
  delete 'delete_device', to: 'devices#destroy'
  post 'merge_devices', to: 'devices#merge'
  get 'retry_download', to: 'download#retry_download'
end

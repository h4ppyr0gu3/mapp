# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :songs
  devise_for :users

  # Static pages
  root to: 'static_pages#home'
  get 'privacy', to: 'static_pages#privacy_policy'
  post 'contact_mail', to: 'static_pages#contact_mail'
  get 'contact', to: 'static_pages#contact'
  get 'terms', to: 'static_pages#terms_of_use'
  get 'copyright', to: 'static_pages#copyright_claims'

  # Search
  get 'search', to: 'search#get'
  post 'search', to: 'search#post'
  get 'user_songs', to: 'songs#user_index'

  # Playlist
  post 'remove', to: 'playlist#remove'
  post 'add', to: 'playlist#add'
  get 'profile', to: 'profiles#show'

  # Devices
  delete 'wipe_device', to: 'devices#wipe_device'
  delete 'delete_device', to: 'devices#destroy'
  post 'merge_devices', to: 'devices#merge'

  # Downloads
  get 'internal_download', to: 'download#internal'
  get 'external_download', to: 'download#external'
  get 'update_download', to: 'download#update'
  get 'download_all', to: 'download#all'
  get 'retry_download', to: 'download#retry'
end

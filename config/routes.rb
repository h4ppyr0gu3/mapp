# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  mount_griddler
  # constraints lambda { |req| req.session["admin"] } do
    mount Logster::Web => "/logs"
  # end

  namespace "api" do
    mount_devise_token_auth_for "User", at: "auth", controllers: {
      confirmations: 'devise_override/confirmations'
    }
    namespace "v1" do
      resources :tracks, except: [:index]
      resources :notifications
      post "tracks_index", to: "tracks#index"
      get "download_redirect/:id", to: "downloads#redirect"
      get "whoami", to: "miscellaneous#whoami"
    end
  end

  # mount ActionCable.server => '/cable'
  mount Sidekiq::Web => "/sidekiq"
  resources :songs
  devise_for :users

  # Static pages
  root to: "static_pages#home"
  get "privacy", to: "static_pages#privacy_policy"
  post "contact_mail", to: "static_pages#contact_mail"
  get "contact", to: "static_pages#contact"
  get "terms", to: "static_pages#terms_of_use"
  get "copyright", to: "static_pages#copyright_claims"
  get "test", to: "test#test"

  # Search
  get "search", to: "search#get"
  post "search", to: "search#post"

  # Playlist
  get "user_songs", to: "songs#user_index"
  get "update_all_metadata", to: "songs#update_all_metadata"
  get "user_updated", to: "songs#user_updated"
  get "user_not_updated", to: "songs#user_not_updated"
  get "auto_fill", to: "songs#auto_fill"
  get "album_list", to: "songs#album_list"
  post "remove", to: "playlist#remove"
  post "add", to: "playlist#add"
  get "profile", to: "profiles#show"

  # Albums
  get "albums", to: "albums#get"

  # Devices
  delete "wipe_device", to: "devices#wipe_device"
  delete "delete_device", to: "devices#destroy"
  post "merge_devices", to: "devices#merge"

  # Downloads
  get "internal_download", to: "download#internal"
  get "external_download", to: "download#external"
  get "update_download", to: "download#update"
  get "download_all", to: "download#all"
  get "redownload_all", to: "download#redownload_all"
  get "retry_download", to: "download#retry"

  # Notifications
  get "get_uuid", to: "notifications#get_uuid"
  get "mark_as_read", to: "notifications#mark_as_read"
end

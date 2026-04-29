Rails.application.routes.draw do
  get "classroom_rosters/show"
  resource :session
  resources :passwords, param: :token
  resources :classroom_rosters, only: %i[show], param: :uuid
  scope :admin do
    resources :schools do
      resources :students, shallow: true
      resources :classrooms, shallow: true, only: %i[edit update]
    end
  end
  root to: "schools#index"

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end

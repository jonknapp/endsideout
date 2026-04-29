Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  scope :admin do
    resources :schools do
      resources :students, shallow: true
    end
  end
  root to: "schools#index"

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end

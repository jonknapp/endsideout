Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resource :student_session, only: %i[new create destroy]
  resources :student_homes, only: %i[index]
  resources :classroom_rosters, only: %i[show], param: :uuid
  scope :admin do
    resources :schools do
      resources :students, shallow: true
      resources :classrooms, shallow: true, only: %i[index new create edit update] do
        member { get :schedule }
      end
    end
    resources :content_modules do
      resources :links, shallow: true
    end
    resources :classroom_modules, only: %i[update]
  end
  root to: "schools#index"

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end

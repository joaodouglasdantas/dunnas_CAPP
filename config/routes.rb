Rails.application.routes.draw do
  get "dashboard/index"
  devise_for :users, skip: [ :registrations, :passwords ]

  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end

  root to: redirect("/users/sign_in")

  resources :blocos
  resources :chamados do
    resources :comentarios, only: [ :create ]
  end
  resources :tipos_chamado
  resources :status_chamados
  resources :unidades, only: [ :index, :show ]

  resources :usuarios do
    member do
      post :vincular_unidade
      delete :desvincular_unidade
    end
  end

  resources :logs_auditoria, only: [ :index ]

  get "dashboard", to: "dashboard#index"
end

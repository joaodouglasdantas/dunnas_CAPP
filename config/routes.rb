Rails.application.routes.draw do
  get "dashboard/index"
  devise_for :users, skip: [ :registrations, :passwords ]

  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end

  root to: redirect("/users/sign_in")

  resources :chamados do
    resources :comentarios, only: [ :create ]
    member do
      delete :remover_anexo
      get :remover_anexo_get
    end
  end
  resources :blocos
  resources :chamados do
    resources :comentarios, only: [ :create ]
    member do
      delete :remover_anexo
    end
  end
  resources :tipos_chamado
  resources :status_chamados
  resources :unidades, only: [ :index, :show ]

  resources :usuarios do
    member do
      post :vincular_unidade
      delete :desvincular_unidade
      post :vincular_tipo_chamado
      delete :desvincular_tipo_chamado
    end
  end

  resources :logs_auditoria, only: [ :index ]

  get "dashboard", to: "dashboard#index"

  get "/admin/reset", to: "admin_reset#reset"
end

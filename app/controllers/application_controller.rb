class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_current_user

  private

  def apenas_administrador!
    unless current_user.administrador? || current_user.tem_permissao?("gerenciar_blocos")
      redirect_to dashboard_path, alert: "Acesso negado."
    end
  end

  def apenas_administrador_ou_colaborador!
    unless current_user.administrador? || current_user.colaborador? || current_user.tem_permissao?("atualizar_status_chamado")
      redirect_to dashboard_path, alert: "Acesso negado."
    end
  end

  def set_current_user
    Current.usuario = current_user
  end
end

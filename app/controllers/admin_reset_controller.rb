class AdminResetController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :set_current_user

  def reset
    return render plain: "Não autorizado", status: 401 unless params[:token] == ENV["RESET_TOKEN"]

    LogAuditorium.delete_all
    Anexo.delete_all
    Comentario.delete_all
    ColaboradorTipoChamado.delete_all
    Chamado.delete_all
    MoradoresUnidade.delete_all
    Unidade.delete_all
    Bloco.delete_all
    UsuarioPapel.delete_all
    User.delete_all
    PapelPermissao.delete_all
    Permissao.delete_all
    Papel.delete_all
    StatusChamado.delete_all
    TipoChamado.delete_all

    # Roda o seed
    Rails.application.load_seed

    render plain: "✅ Reset feito com sucesso! Login: admin@capp.com | Senha: admin123"
  end
end

class ChamadosController < ApplicationController
  before_action :set_chamado, only: [ :show, :edit, :update, :destroy, :remover_anexo ]

  def index
    if current_user.administrador?
      @chamados = Chamado.all.includes(:unidade, :tipo_chamado, :status_chamado, :usuario)
    elsif current_user.colaborador?
      tipos_ids = current_user.tipos_chamado_responsavel.pluck(:id)
      @chamados = Chamado.where(tipo_chamado_id: tipos_ids)
                         .includes(:unidade, :tipo_chamado, :status_chamado, :usuario)
    else
      @chamados = Chamado.joins(unidade: :moradores_unidades)
                         .where(moradores_unidades: { user_id: current_user.id })
                         .includes(:unidade, :tipo_chamado, :status_chamado)
    end
  end

  def show
    @comentarios = @chamado.comentarios.includes(:usuario)
    @comentario = Comentario.new
  end

  def new
    @chamado = Chamado.new
    @unidades = current_user.unidades
    @tipos = TipoChamado.all
  end

  def create
    @chamado = Chamado.new(chamado_params)
    @chamado.usuario = current_user
    if @chamado.save
      redirect_to @chamado, notice: "Chamado aberto com sucesso."
    else
      @unidades = current_user.unidades
      @tipos = TipoChamado.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @chamado.destroy
    redirect_to chamados_path, notice: "Chamado removido com sucesso."
  end

  def edit
    unless current_user.administrador? || current_user.colaborador? || @chamado.usuario == current_user
      redirect_to chamados_path, alert: "Sem permissão." and return
    end

    @unidades = current_user.unidades
    @tipos = TipoChamado.all
    @status_list = StatusChamado.all if current_user.administrador? || current_user.colaborador?
  end

  def update
    unless current_user.administrador? || current_user.colaborador? || @chamado.usuario == current_user
      redirect_to chamados_path, alert: "Sem permissão." and return
    end

    params_permitidos = if current_user.administrador? || current_user.colaborador?
      chamado_update_params
    else
      # morador só pode editar se o chamado ainda estiver no status padrão
      unless @chamado.status_chamado.padrao?
        redirect_to chamado_path(@chamado), alert: "Não é possível editar um chamado que já está em andamento." and return
      end
      params.require(:chamado).permit(:descricao, :unidade_id, :tipo_chamado_id, anexos: [])
    end

    if @chamado.update(params_permitidos)
      redirect_to chamado_path(@chamado), notice: "Chamado atualizado com sucesso."
    else
      @unidades = current_user.unidades
      @tipos = TipoChamado.all
      @status_list = StatusChamado.all if current_user.administrador? || current_user.colaborador?
      render :edit, status: :unprocessable_entity
    end
  end

  def remover_anexo
    unless @chamado.usuario == current_user || current_user.administrador?
      redirect_to chamado_path(@chamado), alert: "Sem permissão." and return
    end

    unless @chamado.status_chamado.padrao? || current_user.administrador?
      redirect_to chamado_path(@chamado), alert: "Não é possível editar um chamado em andamento." and return
    end

    anexo = @chamado.anexos.find(params[:anexo_id])
    anexo.purge
    redirect_to edit_chamado_path(@chamado), notice: "Anexo removido com sucesso."
  end

  private

  def set_chamado
    @chamado = Chamado.find(params[:id])
  end

  def chamado_params
    params.require(:chamado).permit(:unidade_id, :tipo_chamado_id, :descricao, anexos: [])
  end

  def chamado_update_params
    params.require(:chamado).permit(:status_chamado_id, :descricao)
  end
end

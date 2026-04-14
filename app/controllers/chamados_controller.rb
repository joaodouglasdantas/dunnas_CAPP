class ChamadosController < ApplicationController
  before_action :set_chamado, only: [ :show, :edit, :update, :destroy, :remover_anexo, :remover_anexo_get ]

  def index
    if current_user.administrador?
      base = params[:arquivados].present? ? Chamado.arquivados : Chamado.ativos
      @chamados = base.includes(:unidade, :tipo_chamado, :status_chamado, :usuario)
    elsif current_user.colaborador?
      tipos_ids = current_user.tipos_chamado_responsavel.pluck(:id)
      base = params[:arquivados].present? ? Chamado.arquivados : Chamado.ativos
      @chamados = base.where(tipo_chamado_id: tipos_ids)
                      .includes(:unidade, :tipo_chamado, :status_chamado, :usuario)
    else
      base = params[:arquivados].present? ? Chamado.arquivados : Chamado.ativos
      @chamados = base.joins(unidade: :moradores_unidades)
                      .where(moradores_unidades: { user_id: current_user.id })
                      .includes(:unidade, :tipo_chamado, :status_chamado)
    end

    @chamados = aplicar_filtros(@chamados)
    @status_list = StatusChamado.all
    @tipos_list = TipoChamado.all
    @blocos_list = Bloco.all if current_user.administrador?
    @mostrando_arquivados = params[:arquivados].present?
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
      unless @chamado.status_chamado.padrao?
        redirect_to chamado_path(@chamado), alert: "Não é possível editar um chamado que já está em andamento." and return
      end
      params.require(:chamado).permit(:descricao, :unidade_id, :tipo_chamado_id, anexos: [])
    end

    if @chamado.update(params_permitidos.except(:anexos))
      if params[:chamado][:anexos].present?
        params[:chamado][:anexos].each do |anexo|
          @chamado.anexos.attach(anexo) if anexo.respond_to?(:read)
        end
      end
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

  def remover_anexo_get
    unless @chamado.usuario == current_user || current_user.administrador?
      redirect_to chamado_path(@chamado), alert: "Sem permissão." and return
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

  def aplicar_filtros(chamados)
    chamados = chamados.where(status_chamado_id: params[:status_id]) if params[:status_id].present?
    chamados = chamados.where(tipo_chamado_id: params[:tipo_id]) if params[:tipo_id].present?
    if params[:bloco_id].present? && current_user.administrador?
      chamados = chamados.joins(:unidade).where(unidades: { bloco_id: params[:bloco_id] })
    end
    if params[:periodo].present?
      case params[:periodo]
      when "hoje"
        chamados = chamados.where(created_at: Time.current.beginning_of_day..Time.current.end_of_day)
      when "semana"
        chamados = chamados.where(created_at: 1.week.ago..Time.current)
      when "mes"
        chamados = chamados.where(created_at: 1.month.ago..Time.current)
      end
    end
    chamados.order(created_at: :desc)
  end
end

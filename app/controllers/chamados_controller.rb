class ChamadosController < ApplicationController
  before_action :set_chamado, only: [ :show, :edit, :update ]

  def index
      if current_user.administrador? || current_user.colaborador?
      @chamados = Chamado.all.includes(:unidade, :tipo_chamado, :status_chamado, :usuario)
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

  def edit
      apenas_administrador_ou_colaborador!
      @status_list = StatusChamado.all
  end

  def update
      apenas_administrador_ou_colaborador!
      if @chamado.update(chamado_update_params)
      redirect_to @chamado, notice: "Chamado atualizado com sucesso."
      else
      @status_list = StatusChamado.all
      render :edit, status: :unprocessable_entity
      end
  end

  private

  def set_chamado
      @chamado = Chamado.find(params[:id])
  end

  def chamado_params
      params.require(:chamado).permit(:unidade_id, :tipo_chamado_id, :descricao)
  end

  def chamado_update_params
      params.require(:chamado).permit(:status_chamado_id, :descricao)
  end
end

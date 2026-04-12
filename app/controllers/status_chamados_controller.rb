class StatusChamadosController < ApplicationController
  before_action :apenas_administrador!
  before_action :set_status_chamado, only: [ :edit, :update, :destroy ]

  def index
    @status_chamados = StatusChamado.all
  end

  def new
    @status_chamado = StatusChamado.new
  end

  def create
    @status_chamado = StatusChamado.new(status_chamado_params)
    if @status_chamado.save
      redirect_to status_chamados_path, notice: "Status criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @status_chamado.update(status_chamado_params)
      redirect_to status_chamados_path, notice: "Status atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @status_chamado.destroy
      redirect_to status_chamados_path, notice: "Status removido com sucesso."
    else
      redirect_to status_chamados_path, alert: @status_chamado.errors[:base].first
    end
  end

  private

  def set_status_chamado
    @status_chamado = StatusChamado.find(params[:id])
  end

  def status_chamado_params
    params.require(:status_chamado).permit(:nome, :padrao)
  end
end

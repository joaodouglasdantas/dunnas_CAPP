class BlocosController < ApplicationController
  before_action :apenas_administrador!
  before_action :set_bloco, only: [ :show, :edit, :update, :destroy ]

  def index
    @blocos = Bloco.all
  end

  def show
  end

  def new
    @bloco = Bloco.new
  end

  def create
    @bloco = Bloco.new(bloco_params)
    if @bloco.save
      redirect_to @bloco, notice: "Bloco criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @bloco.update(bloco_params)
      redirect_to @bloco, notice: "Bloco atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bloco.destroy
    redirect_to blocos_path, notice: "Bloco removido com sucesso."
  end

private

  def set_bloco
    @bloco = Bloco.find(params[:id])
  end

  def bloco_params
    params.require(:bloco).permit(:nome, :quantidade_andares, :unidades_por_andar)
  end
end

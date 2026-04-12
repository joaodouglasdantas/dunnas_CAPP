class UsuariosController < ApplicationController
  before_action :apenas_administrador!
  before_action :set_usuario, only: [ :show, :edit, :update, :destroy, :vincular_unidade, :desvincular_unidade ]

  def index
    @usuarios = User.all.includes(:papeis)
  end

  def new
    @usuario = User.new
    @papeis = Papel.all
  end

  def create
    @usuario = User.new(usuario_params)
    if @usuario.save
      atribuir_papel
      redirect_to usuarios_path, notice: "Usuário criado com sucesso."
    else
      @papeis = Papel.all
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @unidades_vinculadas = @usuario.unidades
    @todas_unidades = Unidade.all.includes(:bloco)
  end

  def edit
    @papeis = Papel.all
  end

  def update
    if @usuario.update(usuario_update_params)
      atualizar_papel
      redirect_to usuario_path(@usuario), notice: "Usuário atualizado com sucesso."
    else
      @papeis = Papel.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @usuario.destroy
    redirect_to usuarios_path, notice: "Usuário removido com sucesso."
  end

  def vincular_unidade
    unidade = Unidade.find(params[:unidade_id])
    unless @usuario.unidades.include?(unidade)
      MoradoresUnidade.create!(
        unidade: unidade,
        usuario: @usuario,
        assigned_at: Time.current,
        assigned_by_id: current_user.id
      )
      LogAuditorium.registrar(current_user, "Usuário #{@usuario.nome} vinculado à unidade #{unidade.identificacao} do bloco #{unidade.bloco.nome}")
    end
    redirect_to usuario_path(@usuario), notice: "Unidade vinculada com sucesso."
  end

  def desvincular_unidade
    unidade = Unidade.find(params[:unidade_id])
    MoradoresUnidade.find_by(unidade: unidade, user_id: @usuario.id)&.destroy
    LogAuditorium.registrar(current_user, "Usuário #{@usuario.nome} desvinculado da unidade #{unidade.identificacao} do bloco #{unidade.bloco.nome}")
    redirect_to usuario_path(@usuario), notice: "Unidade desvinculada com sucesso."
  end

  private

  def set_usuario
    @usuario = User.find(params[:id])
  end

  def usuario_params
    params.require(:user).permit(:nome, :email, :password, :password_confirmation)
  end

  def usuario_update_params
    if params[:user][:password].blank?
      params.require(:user).permit(:nome, :email)
    else
      params.require(:user).permit(:nome, :email, :password, :password_confirmation)
    end
  end

  def atribuir_papel
    papel = Papel.find_by(id: params[:papel_id])
    @usuario.papeis << papel if papel
  end

  def atualizar_papel
    return unless params[:papel_id].present?
    return if @usuario == current_user
    novo_papel = Papel.find_by(id: params[:papel_id])
    if novo_papel && !@usuario.papeis.include?(novo_papel)
      papel_anterior = @usuario.papeis.first&.nome || "nenhum"
      @usuario.papeis.clear
      @usuario.papeis << novo_papel
      LogAuditorium.registrar(current_user, "Papel do usuário #{@usuario.nome} alterado de '#{papel_anterior}' para '#{novo_papel.nome}'")
    end
  end
end

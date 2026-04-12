class LogsAuditoriaController < ApplicationController
  before_action :apenas_administrador!

  def index
    @logs = LogAuditorium.all.order(created_at: :desc).includes(:usuario)
  end
end

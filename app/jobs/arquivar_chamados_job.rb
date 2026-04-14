class ArquivarChamadosJob < ApplicationJob
  queue_as :default

  def perform
    Chamado.arquivar_antigos!
    LogAuditorium.registrar(nil, "Arquivamento automático de chamados antigos executado")
  end
end

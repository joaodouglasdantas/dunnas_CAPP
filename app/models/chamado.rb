class Chamado < ApplicationRecord
  belongs_to :unidade
  belongs_to :usuario, class_name: "User", foreign_key: "user_id"
  belongs_to :tipo_chamado
  belongs_to :status_chamado, optional: true

  has_many_attached :anexos
  has_many :comentarios, dependent: :destroy

  validates :descricao, presence: true
  validates :unidade, presence: true
  validates :tipo_chamado, presence: true
  validates :status_chamado, presence: true, on: :update

  before_create :definir_status_padrao
  before_update :registrar_finalizacao
  before_destroy :log_remocao

  after_create :log_criacao
  after_update :log_atualizacao

  scope :ativos, -> { where(arquivado: false) }
  scope :arquivados, -> { where(arquivado: true) }

  def self.arquivar_antigos!
    concluido = StatusChamado.find_by(nome: "Concluído")
    return unless concluido

    where(status_chamado: concluido, arquivado: false)
      .where("finalizado_em < ?", 30.days.ago)
      .update_all(arquivado: true)
  end

  private

  def definir_status_padrao
    self.status_chamado ||= StatusChamado.find_by(padrao: true)
  end

  def registrar_finalizacao
    if status_chamado_id_changed? && status_chamado.nome.downcase == "concluído"
      self.finalizado_em = Time.current
    end
  end

  def log_criacao
    LogAuditorium.registrar(usuario, "Chamado ##{id} aberto por #{usuario.nome} na unidade #{unidade.identificacao}")
  end

  def log_atualizacao
    if saved_change_to_status_chamado_id?
      LogAuditorium.registrar(
        Current.usuario,
        "Chamado ##{id} teve status alterado para #{status_chamado.nome} por #{Current.usuario&.nome}"
      )
    end
  end

  def log_remocao
    LogAuditorium.registrar(usuario, "Chamado ##{id} removido da unidade #{unidade.identificacao}")
  end
end

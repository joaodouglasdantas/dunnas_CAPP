class CreateLogAuditoria < ActiveRecord::Migration[8.1]
  def change
    create_table :log_auditoria do |t|
      t.bigint :usuario_id
      t.string :acao

      t.datetime :created_at, null: false
    end
  end
end

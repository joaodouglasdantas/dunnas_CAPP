# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_14_225626) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "anexos", force: :cascade do |t|
    t.bigint "chamado_id", null: false
    t.datetime "created_at", null: false
    t.string "nome_arquivo"
    t.datetime "updated_at", null: false
    t.string "url_arquivo"
    t.index ["chamado_id"], name: "index_anexos_on_chamado_id"
  end

  create_table "blocos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome"
    t.integer "quantidade_andares"
    t.integer "unidades_por_andar"
    t.datetime "updated_at", null: false
  end

  create_table "chamados", force: :cascade do |t|
    t.boolean "arquivado", default: false, null: false
    t.datetime "created_at", null: false
    t.text "descricao"
    t.datetime "finalizado_em"
    t.bigint "status_chamado_id", null: false
    t.bigint "tipo_chamado_id", null: false
    t.bigint "unidade_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["status_chamado_id"], name: "index_chamados_on_status_chamado_id"
    t.index ["tipo_chamado_id"], name: "index_chamados_on_tipo_chamado_id"
    t.index ["unidade_id"], name: "index_chamados_on_unidade_id"
    t.index ["user_id"], name: "index_chamados_on_user_id"
  end

  create_table "colaborador_tipos_chamados", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "tipo_chamado_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
  end

  create_table "comentarios", force: :cascade do |t|
    t.bigint "chamado_id", null: false
    t.datetime "created_at", null: false
    t.text "mensagem"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["chamado_id"], name: "index_comentarios_on_chamado_id"
    t.index ["user_id"], name: "index_comentarios_on_user_id"
  end

  create_table "log_auditoria", force: :cascade do |t|
    t.string "acao"
    t.datetime "created_at", null: false
    t.bigint "usuario_id"
  end

  create_table "moradores_unidades", force: :cascade do |t|
    t.datetime "assigned_at"
    t.bigint "assigned_by_id"
    t.datetime "created_at", null: false
    t.bigint "unidade_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["unidade_id"], name: "index_moradores_unidades_on_unidade_id"
    t.index ["user_id"], name: "index_moradores_unidades_on_user_id"
  end

  create_table "papel_permissaos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "papel_id", null: false
    t.bigint "permissao_id", null: false
    t.datetime "updated_at", null: false
    t.index ["papel_id"], name: "index_papel_permissaos_on_papel_id"
    t.index ["permissao_id"], name: "index_papel_permissaos_on_permissao_id"
  end

  create_table "papels", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "descricao"
    t.string "nome"
    t.datetime "updated_at", null: false
  end

  create_table "permissaos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "descricao"
    t.string "nome"
    t.datetime "updated_at", null: false
  end

  create_table "status_chamados", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome"
    t.boolean "padrao"
    t.datetime "updated_at", null: false
  end

  create_table "tipo_chamados", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "sla_horas"
    t.string "titulo"
    t.datetime "updated_at", null: false
  end

  create_table "unidades", force: :cascade do |t|
    t.bigint "bloco_id", null: false
    t.datetime "created_at", null: false
    t.string "identificacao"
    t.integer "numero_andar"
    t.integer "numero_unidade"
    t.datetime "updated_at", null: false
    t.index ["bloco_id"], name: "index_unidades_on_bloco_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "nome"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "usuario_papels", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "papel_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "usuario_id", null: false
    t.index ["papel_id"], name: "index_usuario_papels_on_papel_id"
    t.index ["usuario_id"], name: "index_usuario_papels_on_usuario_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "anexos", "chamados"
  add_foreign_key "chamados", "status_chamados"
  add_foreign_key "chamados", "tipo_chamados"
  add_foreign_key "chamados", "unidades"
  add_foreign_key "chamados", "users"
  add_foreign_key "comentarios", "chamados"
  add_foreign_key "comentarios", "users"
  add_foreign_key "moradores_unidades", "unidades"
  add_foreign_key "moradores_unidades", "users"
  add_foreign_key "papel_permissaos", "papels"
  add_foreign_key "papel_permissaos", "permissaos"
  add_foreign_key "unidades", "blocos"
  add_foreign_key "usuario_papels", "papels"
  add_foreign_key "usuario_papels", "users", column: "usuario_id"
end

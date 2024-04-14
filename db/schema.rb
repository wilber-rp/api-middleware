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

ActiveRecord::Schema[7.1].define(version: 2024_04_14_193314) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "orders", force: :cascade do |t|
    t.string "order_number"
    t.string "model"
    t.string "deceased_name"
    t.string "costumer_full_name"
    t.string "cpf"
    t.string "company_name"
    t.string "cnpj"
    t.string "ie"
    t.string "address"
    t.string "number"
    t.string "complement"
    t.string "neighborhood"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "email"
    t.string "phone_number"
    t.bigint "source_id", null: false
    t.bigint "payment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "no_invoice"
    t.index ["payment_id"], name: "index_orders_on_payment_id"
    t.index ["source_id"], name: "index_orders_on_source_id"
  end

  create_table "payments", force: :cascade do |t|
    t.string "description"
    t.string "installment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sources", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "orders", "payments"
  add_foreign_key "orders", "sources"
end

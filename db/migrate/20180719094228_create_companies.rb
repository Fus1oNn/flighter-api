class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name, null: false, unique: true

      t.timestamps null: false
    end
  add_index :companies, :name, unique: true
  end
end

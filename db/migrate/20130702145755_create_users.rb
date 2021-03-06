class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :lastname, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.references :account, null: false, index: true

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end

class DeviseTokenAuthCreateUsers < ActiveRecord::Migration
  def up
    User.connection.execute "ALTER TABLE users ADD COLUMN uid character varying NOT NULL DEFAULT md5(random()::text)"

    change_table(:users) do |t|
      ## Required
      t.string :provider,
               null: false,
               default: "email"
      # t.string :uid,
      #          null: false,
      #          default: "SELECT md5(random()::text);" # postgresql only

      ## Tokens
      t.json :tokens
    end

    add_index :users, [:uid, :provider], unique: true
  end

  def down
    remove_index :users, [:uid, :provider]
    change_table(:users) do |t|
      t.remove :provider,
               :uid,
               :tokens
    end
  end
end

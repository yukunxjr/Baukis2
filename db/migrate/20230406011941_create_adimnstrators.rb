class CreateAdimnstrators < ActiveRecord::Migration[6.1]
  def change
    create_table :adimnstrators do |t|
      t.string :email, null: false                      # メールアドレス
      t.string :hashed_password                         # パスワード
      t.boolean :suspended, null: false, default: false # 無効フラグ
      t.timestamps
    end

    add_index :adimnstrators, "LOWER(email)", unique: true
  end
end

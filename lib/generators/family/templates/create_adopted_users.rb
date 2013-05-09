class CreateAdoptedUsers < ActiveRecord::Migration
  def change
    create_table :adopted_users do |t|
      t.integer :user_id
      t.integer :adopted_user_id
      t.string :relationship

      t.timestamps
    end
  end
end

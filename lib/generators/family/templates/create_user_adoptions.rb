class CreateUserAdoptions < ActiveRecord::Migration
  def change
    create_table :user_adoptions do |t|
      t.integer :user_id
      t.integer :adopted_user_id
      t.string :relationship_type
      t.string :reference_id
      t.boolean :locked, default: false

      t.timestamps
    end
  end
end

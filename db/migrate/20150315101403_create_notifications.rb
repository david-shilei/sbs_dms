class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :reason
      t.boolean :read
      t.text :message
      t.integer :user_id
      t.integer :from_user_id
      t.integer :document_id

      t.timestamps
    end
  end
end

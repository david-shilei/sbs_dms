class CreateApprovals < ActiveRecord::Migration
  def change
    create_table :approvals do |t|
      t.integer :category_id
      t.integer :user_id
      t.timestamps
    end
  end
end

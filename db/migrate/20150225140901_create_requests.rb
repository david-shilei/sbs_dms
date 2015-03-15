class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :owner_id
      t.integer :requester_id
      t.integer :document_id
      t.text :description
      t.timestamps
    end

    add_index :requests, :owner_id
    add_index :requests, :requester_id
    add_index :requests, :document_id
  end
end

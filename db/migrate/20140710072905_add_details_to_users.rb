class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :employee_number, :string
    add_column :users, :phone, :string
    add_column :users, :mobile, :string
    add_column :users, :full_name, :string
    add_column :users, :is_admin, :boolean, default: false
    add_column :users, :school_id, :integer
    add_column :users, :group_id, :integer
  end
end
class AddDetailsToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :title, :string
    add_column :documents, :code, :string
    add_column :documents, :description, :text
    add_column :documents, :sample, :text
    add_column :documents, :start, :date
    add_column :documents, :end, :date
    add_column :documents, :source, :string
    add_column :documents, :level, :integer, default: 0
    add_column :documents, :category_id, :integer
    add_column :documents, :user_id, :integer
  end
end

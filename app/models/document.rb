class Document < ActiveRecord::Base

  enum level: { personal: 0, group_only: 1, shcool_only: 2, free: 99 }
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  belongs_to :category
  has_many :revisions, dependent: :destroy
  has_many :requests, dependent: :destroy

  validates_presence_of :category

  # Sunspot Solr search configuration for the document object
  searchable do 
    # Give document titles higher weight when determining search results
    text :title, default_boost: 2, stored: true
    text :description, stored: true
    text :revision_search_texts, stored: true do
      revisions.map { |revision| revision.search_text }
    end
  end

  def current_revision
    Revision.where(document_id: id).order("position asc").first
  end

  def total_downloads
    revisions.sum(:download_count)
  end
end

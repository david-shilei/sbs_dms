class Notification < ActiveRecord::Base
  enum reason: { request_document: 1, request_approved: 2 }
  belongs_to :user

  def from
    User.find_by_id(from_user_id)
  end

  def document
    Document.find_by_id(document_id)
  end
end

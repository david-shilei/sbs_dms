class Request < ActiveRecord::Base
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  belongs_to :requester, class_name: "User", foreign_key: "requester_id"
  belongs_to :document

  validates_presence_of :document
  validates_presence_of :owner
  validates_presence_of :requester
end

class School < ActiveRecord::Base

  validates :name, uniqueness: true

  has_many :groups, dependent: :destroy
  has_many :users, dependent: :destroy
end

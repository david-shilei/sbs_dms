class Group < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :users
  has_many :categories
  has_many :documents, through: :categories
  belongs_to :school

  def member_names
    names = Array.new
    users.each { |member| names << member.user.username }
    names.join(", ")
  end

  def category_names
    names = Array.new
    categories.each { |cat| names << cat.name }
    names.join(", ")
  end

end
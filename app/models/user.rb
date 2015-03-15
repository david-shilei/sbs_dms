class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, uniqueness: true

  belongs_to :school
  belongs_to :group
  has_many :documents, dependent: :destroy
  has_many :categories
  has_many :revisions, dependent: :destroy
  has_many :approvals, dependent: :destroy
  has_many :requested_documents, through: :approvals
  has_many :notifications, dependent: :destroy

  after_create :send_admin_mail
  def send_admin_mail
    unless self.is_admin
      # AdminMailer.new_user_waiting_for_approval(self).deliver
    end
  end

  def name
    return full_name if !full_name.nil?
    return username
  end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  def member_of(group_id)
    self.group_id == group_id
  end

  def writable_categories
    categories = []
    Category.all.each do |category|
      # check if category is private or unwritable
      if !category.is_writable or category.is_private
        # if user is a member of the controlling group
        #  they have permission to upload to the private / unwritable category
        if member_of(category.group_id)
          categories << category
        end
      else
        # No restrictions on this group, anyone can upload
        #  as long as they are logged in
        categories << category
      end
    end
    return categories.sort! { |a,b| a.name.downcase <=> b.name.downcase }
  end

  def incoming_requests
    Request.where(owner_id: self.id)
  end

  def new_notifications
    self.notifications.where(read: false)
  end
end

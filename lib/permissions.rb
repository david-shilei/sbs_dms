module Permissions
  # ====================
  # Permission Helpers 
  # ====================

  # Check if the current logged in user is an admin
  #  used as a before_filter for controller security
  def admin?
    current_user.is_admin? if !current_user.nil?
  end

  # ====================
  # Category Permissions
  # ====================

  # Check if the current user can upload documents to the specified category
  def can_upload_documents(category)
    # No category specified
    return false if category.nil?
    # No user logged in
    return false if current_user.nil?
    # Allow admins unrestricted uploads
    return true if current_user.is_admin?

    return true
  end

  def can_edit_category(category)
    return false unless current_user
    return true if current_user.is_admin?

    return current_user == category.owner
  end

=begin
  # Check if the current user can upload documents to the specified category
  def upload_permitted_categories
    # Return all categories the current user can upload to
    return nil if current_user.nil?
    permitted_categories = Category.all if current_user.is_admin?
    permitted_categories ||= current_user.writable_categories
  end
=end

  # ====================
  # Document Permissions
  # ====================

  # Check if the current user can revise a specific document
  def can_revise_document(document)
    # # deny user if not logged in
    # return false if current_user.nil?
    # # current user is an admin
    # return true if current_user.is_admin?
    # # current user is a member of the category's
    # #   group for a document that is write protected
    # unless document.category.group.nil? and document.is_writable?
    #   return current_user.member_of(document.category.group.id)
    # end
    return can_download_document(document)
  end

  # Check if the current user can view a specific document
  def can_download_document(document)
    return false if current_user.nil?
    return true if current_user.is_admin?
    return true if current_user == document.owner

    case document.level
      when 'group_only'
        return true if current_user.group && current_user.group_id == document.owner.group_id
      when 'school_only'
        return true if current_user.school && current_user.school_id == document.owner.school_id
      when 'free'
        return true
    end

    return true if document.category.readers.include?(current_user)

    return false
  end

  # Check if the current user can edit a specific document
  def can_edit_document(document)
    # deny user if not logged in
    return false if current_user.nil?
    # current user is an admin
    return true if current_user.is_admin?
    # current user is a member of the owner's group

    return document.owner == current_user
    # User is not an admin and not a member of the category's group
    return false
  end

end
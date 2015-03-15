class CategoriesController < ApplicationController

  before_filter :admin?, except: [:index, :show, :create_subcategory]

  # GET /categories
  def index
    @categories = Category.all.order("name asc").page(params[:page])
  end

  # GET /categories/:id
  def show
    # Get category and its subcategories
    @category = Category.find params[:id]
    @subcategories = @category.children.sort_by {|c| c.name}
    @groups = Group.order(:name).all.map {|group| [group.name, group.id]}

    # Get all documents associated with this category
    @documents = Document.where(category_id: @category.id).order("updated_at desc").page(params[:page])

    # Check if a view style (list or grid) is specified
    if params.key?(:view_style)
      @view_style = params[:view_style]
    else
      # Default to list view
      @view_style = "grid"
    end

    respond_to do |format|
      format.html {}
    end
  end

  def new
    @category = Category.new
    # Get categories and groups for selection dropdowns
    @categories = Category.all.map {|cat| [cat.name, cat.id]}
    @groups = Group.all.map {|group| [group.name, group.id]}
  end

  def create
    @category = Category.new(category_params)
    @category.owner = current_user
    if @category.save
      redirect_to @category
    else
      flash[:error] = "Unable to save category: #{@category.errors.full_messages.to_sentence}"
      redirect_to "/"
    end
  end

  def create_subcategory
    # Get parent category the new subcategory will be under
    @parent_category = Category.find_by_id(params[:id])

    # Check hidden field value for invalid parent category
    if @parent_category.nil? 
      redirect_to "/"
    end

    # Check if user is logged in / an admin, or a leader of the parent group
    if admin? or current_user.leader_of(@parent_category.group_id)
      # Create subcategory using parent attributes for group id, writability, and visibility
      if Category.create_using_parent_attributes(subcategory_params)
        flash[:success] = "Subcategory successfully created."
      else
        # Error saving subcategory
        flash[:error] = "Unable to create subcategory."
      end
    else
      # Permissions error
      flash[:error] = "Unable to create subcategory. You do not have the required permissions."
    end

    redirect_to category_path(@parent_category)
  end

  def edit
    @category = Category.find_by_id(params[:id])
    # Get categories and groups for selection dropdowns
    @categories = Category.all.map {|cat| [cat.name, cat.id]}
    @categories.delete([@category.name, @category.id])
    @groups = Group.all.map {|group| [group.name, group.id]}
  end

  def update
    @category = Category.find_by_id(params[:id])
    @category.update_attributes(category_params)
    redirect_to edit_category_path(@category)
  end

  def destroy
    @category = Category.find_by_id(params[:id]).destroy
    redirect_to manage_categories_path
  end

  def subcategories
    @subcategories = Category.find(params[:id]).children.sort_by{|c| c.name}
    @subcategories = @subcategories.map{|c| c.subcategories_json}
    render json: @subcategories 
  end

  private
    def category_params
      params.require(:category).permit(:name, :description,
        :group_id, :is_featured, :is_private, :is_writable)
    end

    def subcategory_params
      params.require(:category).permit(:name, :description, 
        :is_featured, :group_id, :parent_id)
    end
end

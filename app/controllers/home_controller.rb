class HomeController < ApplicationController
  before_filter :admin?, except: [:index, :show, :create_subcategory]

  # GET /categories
  def index
    # Get all viewable categories
    @categories = Category.roots.order(name: :asc)

    # Get featured categories and recently uploaded documents
    #  making sure to hide private docs and categories
    @featured = Category.featured

    @documents = Document.order("updated_at desc").first(5)
  end

  def me
    my_documents = current_user.documents

    @categories = current_user.categories
    @categories += my_documents.map(&:category)
    @categories.uniq!

    if params[:category_id]
      @selected_category = @categories.find{|c| c.id.to_s == params[:category_id]}
    else
      @selected_category = @categories.first
    end

    if @selected_category
      @documents = @selected_category.documents.where(user_id: current_user.id)
    else
      @documents = []
    end
  end

  def intro

  end

  def guide

  end

  def news

  end
end
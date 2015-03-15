class Category < ActiveRecord::Base
  # Based on contributions from @bamnet on the 3.1 branch

  # Build a heirarchy of categories
  belongs_to :parent, class_name: 'Category'
  has_many :children, class_name: 'Category', foreign_key: 'parent_id'
  has_many :documents
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  has_many :approvals, dependent: :destroy
  has_many :readers, through: :approvals, source: :user
  belongs_to :group

  # Category validations
  validates :name, presence: true, uniqueness: true
  validates_presence_of :owner

  # Set subcategory group, visibility, and writability based on parents
  def self.create_using_parent_attributes(params)
    # Fetch parent category and create new subcategory using params
    parent_category = Category.find_by_id(params[:parent_id])
    subcategory = Category.new(params)

    # Set attributes based on parent category for consistency
    subcategory.is_private = parent_category.is_private
    subcategory.is_writable = parent_category.is_writable

    # Attempt to save our new subcategory
    return subcategory.save
  end

  # Find all categories serving as a root
  def self.roots
    categories = Category.where(parent_id: nil)
  end

  # Is this category a root?
  def is_root?
    parent_id.nil?
  end

  # Get the root of the current category
  def root
    return self if is_root?
    ancestors.select { |category| category.is_root? }.first
  end

  # Collect a list of parent categories
  # Each category the monkey stops as he climbs up the tree
  # Compliments of DHH http://github.com/rails/acts_as_tree
  def ancestors
    node, nodes = self, []
    nodes << node = node.parent while node.parent
    nodes
  end

  # Collect a list of children categories
  # Each category the monkey could stop by as he climbs down a tree
  # Compliments of http://github.com/funkensturm/acts_as_category
  def descendants
    node, nodes = self, []
    node.children.each { |child|
      # Check for circular dependencies
      if !nodes.include?(child)
        nodes += [child]
        nodes += child.descendants
      end
    } unless node.children.empty?
    nodes
  end

  # Figure out a node's depth
  def depth
    ancestors.count
  end

  # The group of category who share a common parent
  def self_and_siblings
    parent ? parent.children : Category.roots
  end

  def self.featured
    # Show featured categories & their documents on the home page
    #  Select featured and public categories
    categories = Category.order("random()").where(is_featured: true).limit(3)

    featured_docs = {}
    # select a categories documents that are private, order by upload date
    #  and choose only the most recent four to display
    categories.each do |category| 
      featured_docs[category] = category.documents.where(is_private: false).order("updated_at desc").limit(3)
    end

    featured_docs
  end

  # Define only the json attributes we need for the frontend
  def subcategories_json
    {id: id, name: name, depth: depth}
  end

  def is_owner?(user)
    user && user.id == user_id
  end
end

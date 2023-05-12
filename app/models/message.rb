class Message < ApplicationRecord
  belongs_to :customer
  belongs_to :staff_member, optional: true
  belongs_to :root, class_name: "Message", foreign_key: "root_id",
    optional: true
  belongs_to :parent, class_name: "Message", foreign_key: "parent_id",
    optional: true
  # has_many :children, class_name: "Message", foreign_key: "parent_id",
  #   dependent: :destroy
  has_many :message_tag_links, dependent: :destroy
  has_many :tags, -> { order(:value) }, through: :message_tag_links

  before_validation do
    if parent
      self.customer = parent.customer
      self.root = parent.root || parent
    end
  end

  attr_accessor :child_nodes

  def tree
    return @tree if @tree
    r = root || self
    messages = Message.where(root_id: r.id).select(:id, :parent_id, :subject)
    @tree = SimpleTree.new(r, messages)
  end

  def add_tag(label)
    self.class.transaction do
      HashLock.acquire("tags", "value", label)
      tag = Tag.find_by(value: label)
      tag ||= Tag.create!(value: label)
      unless message_tag_links.where(tag_id: tag.id).exists?
        message_tag_links.create!(tag_id: tag.id)
      end
    end
  end

  def remove_tag(label)
    self.class.transaction do
      HashLock.acquire("tags", "value", label)
      if tag = Tag.find_by(value: label)
        message_tag_links.find_by(tag_id: tag.id).destroy
        if tag.message_tag_links.empty?
          tag.destroy
        end
      end
    end
  end


  validates :subject, presence: true, length: { maximum: 80 }
  validates :body, presence: true, length: { maximum: 800 }

  scope :not_deleted, -> { where(deleted: false) }
  scope :deleted, -> { where(deleted: true) }
  scope :sorted, -> { order(created_at: :desc) }
  scope :tagged_as, -> (tag_id) do
    if tag_id
      joins(:message_tag_links).where("message_tag_links.tag_id" => tag_id)
    else
      self
    end
  end

end

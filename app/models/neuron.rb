# == Schema Information
#
# Table name: neurons
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  active     :boolean          default(FALSE)
#  deleted    :boolean          default(FALSE)
#  is_public  :boolean          default(FALSE)
#  position   :integer          default(0)
#

class Neuron < ActiveRecord::Base
  include Relationable

  has_paper_trail ignore: [:created_at, :id]

  STATES = %w(active inactive)

  STATES.map(&:to_sym).each do |state|
    scope state, -> {
      where(active: state == :active)
    }
  end

  scope :published, -> {
    where(is_public: true)
  }

  scope :not_deleted, -> {
    where(deleted: false)
  }

  begin :relationships
    has_many :contents,
             dependent: :destroy
    has_many :approved_contents,
             -> { Content.approved },
             class_name: "Content"
    belongs_to :parent, class_name: "Neuron"
  end

  begin :callbacks
    after_touch :update_active_state!
    before_create :set_position!
  end

  accepts_nested_attributes_for :contents,
    allow_destroy: true,
    reject_if: ->(attributes) {
      required_attrs = %w(
        description
        source
      )
      required_attrs.all? do |attr|
        attributes[attr].blank?
      end
    }

  begin :validations
    validates :title, presence: true,
                      uniqueness: true
    validate :parent_is_not_child,
             if: ->{ parent_id.present? }
    validate :check_is_public,
              on: :update,
              :if => :deleted?
  end

  def to_s
    title
  end

  ##
  # builds a content for each level & kind
  def build_contents!
    Content::LEVELS.each do |level|
      Content::KINDS.each do |kind|
        unless contents_any?(level: level, kind: kind)
          contents.build(level: level, kind: kind)
        end
      end
    end
    self
  end

  ##
  # Saves and touches a version
  #
  # @param opts [Hash] options passed to #save
  # @yield [version] created version (if any)
  # @return [Boolean] if the record was saved or not
  def save_with_version(opts={})
    changed = changed? # if not already creating version
    relationships_changed = relationships_changed?
    transaction do
      save(opts).tap do |saved|
        if saved && !changed && relationships_changed
          touch_with_version
        end

        # only if a version was created
        if changed || relationships_changed
          yield versions.last if block_given?
        end
      end
    end
  end

  def children_neurons
    @children_neurons ||= self.class.where(parent_id: id)
                                    .order(:position)
  end

  def eager_contents!
    self.contents = contents.eager
    self
  end

  private

  ##
  # validates parent is not a child or child of any of their
  # children
  def parent_is_not_child
    parent_is_child = false
    candidate = Neuron.find_by(id: parent_id)
    while candidate.present? && candidate.parent_id.present? && !parent_is_child
      parent_is_child = candidate.parent_id == id
      candidate = candidate.parent
    end
    errors.add(
      :parent,
      I18n.t(
        "activerecord.errors.messages.circular_parent",
        child: parent.to_s,
        parent: self.to_s
      )
    ) if parent_is_child
  end

  def check_is_public
    errors.add(
      :deleted,
      I18n.t("activerecord.errors.messages.cannot_delete_neuron",
              neuron: self)
    ) if is_public?
  end

  ##
  # marks `active` flag as true if any of the contents
  # is approved. Marks it false otherwise
  def update_active_state!
    self.active = contents_any?(approved: true)
    if active_changed?
      self.paper_trail_event = "active_neuron"
      save!
    end
  end

  def set_position!
    if parent.present?
      self.position = parent.children_neurons.maximum(:position).to_i + 1
    end
  end
end

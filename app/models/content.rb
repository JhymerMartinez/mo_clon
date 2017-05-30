# == Schema Information
#
# Table name: contents
#
#  id          :integer          not null, primary key
#  level       :integer          not null
#  kind        :string           not null
#  description :text             not null
#  neuron_id   :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  source      :string
#  approved    :boolean          default(FALSE)
#  title       :string
#  media_count :integer          default(0)
#

class Content < ActiveRecord::Base
  include ContentAnnotable
  include SpellcheckAnalysable

  LEVELS = %w(1 2 3).map!(&:to_i)
  NUMBER_OF_LINKS = 3
  NUMBER_OF_VIDEOS = 1
  NUMBER_OF_POSSIBLE_ANSWERS = 3
  SPELLCHECK_ATTRIBUTES = %w(
    title
    description
  ).freeze
  KINDS = %{
    que-es
    como-funciona
    por-que-es
    quien-cuando-donde
  }.split("\n").map(&:squish).map(&:to_sym).reject(&:blank?)

  has_paper_trail ignore: [:created_at, :updated_at, :id]

  acts_as_taggable_on :keywords

  begin :relationships
    belongs_to :neuron, touch: true

    # these belong to user
    has_many :content_readings
    has_many :content_learnings
    has_many :content_notes
    has_many :content_tasks

    has_many :possible_answers,
             ->{ order :id },
             dependent: :destroy
    has_many :content_links,
             dependent: :destroy
    has_many :content_videos,
             dependent: :destroy
    has_many :content_medium,
             class_name: "ContentMedia",
             dependent: :destroy
  end

  begin :nested_attributes
    accepts_nested_attributes_for :possible_answers,
      reject_if: ->(attributes) {
        attributes["text"].blank?
      }

    accepts_nested_attributes_for :content_medium,
      allow_destroy: true,
      reject_if: ->(attributes) {
        attributes["media"].blank?
      }

    accepts_nested_attributes_for :content_links,
      reject_if: ->(attributes) {
        attributes["link"].blank?
      }

    accepts_nested_attributes_for :content_videos,
      allow_destroy: true,
      reject_if: ->(attributes) {
        attributes["url"].blank?
      }
  end

  begin :scopes
    scope :eager, -> {
      includes(
        :spellcheck_analyses,
        possible_answers: :spellcheck_analyses
      )
    }
    scope :approved, ->(status=true) {
      where(approved: status)
    }
    scope :with_media, -> {
      where("media_count > 0")
    }
  end

  begin :callbacks
    after_update :log_approve_neuron
  end

  begin :validations
    validates :level, presence: true,
                      inclusion: {in: LEVELS}
    validates :kind, presence: true,
                     inclusion: {in: KINDS}
    validate :has_description_media_or_links
    validates :source, presence: true
  end

  def able_to_have_more_links?
    content_links.length < NUMBER_OF_LINKS
  end

  def able_to_have_more_videos?
    content_videos.length < NUMBER_OF_VIDEOS
  end

  def kind
    read_attribute(:kind).try :to_sym
  end

  def log_approve_neuron
    if self.approved_changed?
      self.neuron.paper_trail_event = "approve_content"
      self.neuron.touch_with_version
    end
  end

  def build_possible_answers!
    max = NUMBER_OF_POSSIBLE_ANSWERS
    remaining = max - possible_answers.length
    1.upto(remaining).map do
      possible_answers.build
    end
  end

  private

  def has_description_media_or_links
    if description.blank? && content_medium.empty? && content_links.empty?
      errors.add(
        :base,
        I18n.t("activerecord.errors.messages.content_has_description_media_or_links")
      )
    end
  end
end

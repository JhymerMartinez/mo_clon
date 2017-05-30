module Admin
  module Neurons
    class BaseController < AdminController::Base
      include Breadcrumbs

      expose(:neuron, attributes: :neuron_params)
      alias_method :resource, :neuron

      expose(:decorated_neuron) {
        decorate neuron
      }

      expose(:formatted_contents) {
        neuron.build_contents!
        neuron.contents.inject({}) do |memo, content|
          memo[content.level] ||= Hash.new
          memo[content.level][content.kind] ||= Array.new
          decorated_content = decorate(content)
          decorated_content.build_possible_answers!
          memo[content.level][content.kind] << decorated_content
          memo
        end
      }

      private

      def breadcrumb_base
        "neuron"
      end

      def neuron_params
        params.require(:neuron)
              .permit :id,
                      :title,
                      :parent_id,
                      :is_public,
                      :deleted,
                      :contents_attributes => [
                        :id,
                        :kind,
                        :level,
                        :title,
                        :description,
                        :neuron_id,
                        :_destroy,
                        :keyword_list,
                        :source,
                        :possible_answers_attributes => [
                          :id,
                          :correct,
                          :text
                        ],
                        :content_medium_attributes => [
                          :id,
                          :_destroy,
                          :media,
                          :media_cache
                        ],
                        :content_links_attributes => [
                          :id,
                          :link
                        ],
                        :content_videos_attributes => [
                          :id,
                          :url
                        ]
                      ]
      rescue ActionController::ParameterMissing
        Hash.new
      end
    end
  end
end

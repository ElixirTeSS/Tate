module Tate
  class TextValue < ActiveRecord::Base
    include AnnotationsVersionFu

    validates_presence_of :text

    acts_as_annotation_value :content_field => :text

    before_validation :init

    def init
      self.version = 1
    end

    belongs_to :version_creator,
               :class_name => "::#{Tate::Engine.user_model_name}"

    # ========================
    # Versioning configuration
    # ------------------------

    annotations_version_fu do
      validates_presence_of :text

      belongs_to :version_creator,
                 :class_name => "::#{Tate::Engine.user_model_name}"
    end

    # ========================
  end
end
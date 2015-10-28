module Tate
  class NumberValue < ActiveRecord::Base
    include AnnotationsVersionFu

    validates_presence_of :number

    acts_as_annotation_value :content_field => :number

    belongs_to :version_creator,
               :class_name => "::#{Tate::Engine.user_model_name}"

    # ========================
    # Versioning configuration
    # ------------------------

    before_validation :init

    def init
      self.version = 1
    end


    annotations_version_fu do
      validates_presence_of :number

      belongs_to :version_creator,
                 :class_name => "::#{Tate::Engine.user_model_name}"
    end

    # ========================
  end
end
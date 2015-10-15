module Tate
  class AnnotationAttribute < ActiveRecord::Base
  validates_presence_of :name,
                        :id

  validates_uniqueness_of :name,
                          :case_sensitive => false

  validates_uniqueness_of :id,
                          :case_sensitive => false

  has_many :annotations,
           :foreign_key => "attribute_id"

  before_validation :set_identifier

  # If the identifier is not set, generate it before validation takes place.
  # See Tate::Engine::default_attribute_identifier_template
  # for more info.
  #
  # The rules are:
  # - if an identifier is manually set, nothing happens.
  # - if no identifier is set:
  #   - if name is enclosed in chevrons (eg: <http://...>) then the chevrons are taken out and the result is the new identifier.
  #   - if name is a URI beginning with http:// or urn: then this is used directly as the identifier.
  #   - in all other cases the identifier will be generated using the template specified by
  #     Tate::Engine::default_attribute_identifier_template, where '%s' in the template will be replaced with
  #     the transformation of 'name' through the Proc specified by Tate::Engine::attribute_name_transform_for_identifier.
  def set_identifier
    unless self.name.blank? or !self.id.blank?
      if self.name.match(/^<.+>$/)
        self.id = self.name[1, self.name.length-1].chop
      elsif self.name.match(/^http:\/\//) or self.name.match(/^urn:/)
        self.id = self.name
      else
        self.id = (Tate::Engine::default_attribute_identifier_template % Tate::Engine::attribute_name_transform_for_identifier.call(self.name))
      end
    end
  end
end
end
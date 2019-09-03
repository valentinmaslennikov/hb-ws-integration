module ActiveRecordConcern
  extend ActiveSupport::Concern

  class_methods do
    def update_or_create(attributes)
      assign_or_new(attributes).save
    end

    def assign_or_new(attributes)
      obj = first || new
      obj.assign_attributes(attributes)
      obj
    end
  end
end
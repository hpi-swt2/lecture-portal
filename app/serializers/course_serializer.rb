class CourseSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :status
end

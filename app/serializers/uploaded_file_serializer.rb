class UploadedFileSerializer < ActiveModel::Serializer
  attributes :id, :content_type, :filename, :data
end

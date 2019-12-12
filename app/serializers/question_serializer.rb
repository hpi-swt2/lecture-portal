class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :content, :author_id, :created_at, :upvotes, :can_be_upvoted

  def can_be_upvoted
    if defined?(current_user)
      (current_user.id != object.author_id) && (!object.upvoter_ids.include?(current_user.id))
    end
  end

end

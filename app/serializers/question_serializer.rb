class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :content, :author_id, :created_at, :upvotes, :already_upvoted, :resolved

  def already_upvoted
    if defined?(current_user) and current_user != nil
      (current_user.id != object.author_id) && (object.upvoter_ids.include?(current_user.id))
    end
  end

  def current_user
    @instance_options[:current_user]
  end
end

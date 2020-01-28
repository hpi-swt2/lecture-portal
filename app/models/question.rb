class Question < ApplicationRecord
  belongs_to :lecture
  belongs_to :author, class_name: :User
  has_and_belongs_to_many :upvoters, class_name: :User

  validates :lecture, presence: true
  validates :content, presence: true
  validates :author, presence: true

  def upvotes
    upvoters.count
  end

  def Question.questions_for_lecture(lecture, current_user)
    if current_user.is_student
      ActiveModelSerializers::SerializableResource.new(
        Question.where(lecture: lecture).order(created_at: :DESC),
          each_serializer: QuestionSerializer,
          current_user: current_user
      )
    else
      ActiveModelSerializers::SerializableResource.new(
        Question.where(lecture: lecture)
            .left_joins(:upvoters)
            .group(:id)
            .order(Arel.sql("COUNT(users.id) DESC"), created_at: :DESC),
          each_serializer: QuestionSerializer,
          current_user: current_user
      )
    end
  end
end

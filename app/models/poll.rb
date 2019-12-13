class Poll < ApplicationRecord
  has_many :poll_options, dependent: :destroy
  has_many :answers, dependent: :destroy
  belongs_to :lecture
  validates :title, presence: true
  validates :is_multiselect, inclusion: { in: [true, false] }
  validates :is_active, inclusion: { in: [true, false] }
  validate :only_one_poll_active

  def only_one_poll_active
    if is_active && Poll.where(lecture_id: lecture.id, is_active: true).where.not(id: id).length > 0
      errors.add(:only_one_poll_can_be_active, "There can be only one poll active for one lecture.")
    end
  end

  def gather_vote_results
    # reset number of votes for options
    poll_options.each do |option|
      option.update(votes: 0)
    end

    # gather votes for options from answers
    answers.each do |answer|
      current_option = PollOption.find(answer.option_id)
      current_option.votes += 1
      current_option.save
    end
  end
end

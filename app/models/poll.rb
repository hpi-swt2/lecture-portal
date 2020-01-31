class Poll < ApplicationRecord
  has_many :poll_options, dependent: :destroy
  has_many :answers, dependent: :destroy
  belongs_to :lecture
  validates :title, presence: true
  validates :is_multiselect, inclusion: { in: [true, false] }
  validates :is_active, inclusion: { in: [true, false] }

  def close
    self.update(is_active: false)
  end

  def sorted_options
    poll_options.sort_by { | opt | opt.index }
  end

  def gather_vote_results
    reset_votes(poll_options)
    gather_votes(answers)
  end

  def reset_votes(poll_options)
    poll_options.each do |option|
      option.update(votes: 0)
    end
  end

  def gather_votes(answers)
    answers.each do |answer|
      current_option = PollOption.find(answer.option_id)
      current_option.votes += 1
      current_option.save
    end
  end
end

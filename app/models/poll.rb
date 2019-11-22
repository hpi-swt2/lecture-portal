class Poll < ApplicationRecord
  has_many :poll_options, dependent: :destroy
end

class Calendar < ApplicationRecord
  before_create :assign_hash_id

  private
  def assign_hash_id
    self.hash_id = SecureRandom.urlsafe_base64(20) until unique_hash_id?
  end

  def unique_hash_id?
    !self.class.exists?(hash_id: self.hash_id)
  end

end

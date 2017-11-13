class Preference < ApplicationRecord
  belongs_to :user
  self.primary_key = 'user_id'
  validates_uniqueness_of :user_id, message: "can not have more than one preference"

end
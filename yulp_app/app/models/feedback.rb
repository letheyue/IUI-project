class Feedback < ApplicationRecord

  def self.from_user data
    # byebug
    f = Feedback.new
    f.subject = data["subject"]
    f.content = data["content"]
    f.user_id = data["user_id"].to_i
    f.save!

  end


end

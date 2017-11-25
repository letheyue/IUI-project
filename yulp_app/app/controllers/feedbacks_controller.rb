class FeedbacksController < ApplicationController
  include SessionsHelper



  def save
    Feedback.from_user(params)
    # byebug
    render :json => {:data => 'Success'}
  end

end
class SearchHistory < ApplicationRecord

  belongs_to :user

  self.table_name = 'search_histories'




  def self.from_search(search_term, current_user)
    history = SearchHistory.new
    term = search_term.gsub(/\s+/, '')
    current_history = SearchHistory.find_by query_term: term
    if current_history
      history = current_history
      history.update_attribute(:times, history.times+1)
    else
      history.query_term = term
      history.user_id = current_user.id
      history.times = 1
      history.save!
    end
  end


end

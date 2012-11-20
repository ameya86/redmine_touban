class ToubanUser < ActiveRecord::Base
  include Redmine::SafeAttributes

  belongs_to :touban
  belongs_to :user

  safe_attributes :user_id, :touban_id

  acts_as_list :scope => :touban_id # リスト
end

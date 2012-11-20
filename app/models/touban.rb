class Touban < ActiveRecord::Base
  include Redmine::SafeAttributes

  belongs_to :project
  has_many :touban_users, :dependent => :destroy
  has_many :users, :through => :touban_users, :source => :user

  serialize :tasks # 配列として保存

  safe_attributes :name, :description, :tasks, :step, :user_ids

  validates_presence_of :name, :project, :tasks, :step

  # 今日の当番の組み合わせ
  def today_touban
    return @today_touban if @today_touban

    @today_touban = []
    user_index = self.touban_index
    user_count = self.users.length
    self.tasks.each do |task|
      next if task.blank? # 空行には割り当てない
      @today_touban << [self.users[user_index], task]
      user_index = (user_index + 1) % user_count
    end

    return @today_touban
  end

  # 今日の当番ユーザ
  def today_users
    return @today_users if @today_users

    # 最後のユーザを越えるなら、ループさせる
    touban_count = self.tasks.length
    if (self.touban_index + touban_count) > self.users.count
      over = self.touban_index + touban_count - self.users.count
      @today_users = self.users[self.touban_index, (touban_count - over)] + self.users[0, over]
      @today_users.uniq!
    else
      @today_users = self.users[self.touban_index, touban_count]
    end

    return @today_users
  end

  # 当番を前に戻す
  def prev_touban
    @today_touban = nil
    @today_users = nil
    user_count = self.users.count
    self.touban_index = (self.touban_index + user_count - self.step) % user_count
  end

  def prev_touban!
    self.prev_touban
    self.save
  end

  # 当番を次に進める
  def next_touban
    @today_touban = nil
    @today_users = nil
    self.touban_index = (self.touban_index + self.step) % self.users.count
  end

  def next_touban!
    self.next_touban
    self.save
  end

  private
  def validate
    if self.step == 0
      self.errors.add(:step, :invalid)
    end
  end
end

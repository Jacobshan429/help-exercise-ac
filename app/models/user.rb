class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :messages
  has_many :comments

  has_many :subscriptions, :dependent => :destroy
  has_many :sub_messages, -> { distinct }, :through => :subscriptions, :source => :message

  has_many :likes, :dependent => :destroy
  has_many :like_messages, -> { distinct }, :through => :likes, :source => :message

  def display_name
    self.email.split("@").first
  end

  def posts_count
    self.messages.count + self.comments.count
  end

  def words_count
    count = 0
    self.messages.find_each do |x|
      count += x.title.split(" ").size if x.title
      count += x.content.split(" ").size if x.content
    end

    self.comments.find_each do |x|
      count += x.content.split(" ").size if x.content
    end

    return count
  end

end

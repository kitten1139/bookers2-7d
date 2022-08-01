class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  has_many :relationships, foreign_key: :follower_id
  has_many :followers, through: :relationships, source: :followed

  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: :followed_id
  has_many :follows, through: :reverse_of_relationships, source: :follower

  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy

  has_many :view_counts, dependent: :destroy

  has_many :group_users
  has_many :groups, through: :group_users

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def is_followed_by?(user)
    reverse_of_relationships.find_by(follower_id: user.id).present?
  end

  def follow(user_id)
  relationships.create(followed_id: user_id)
  end


  def following?(user)
    follows.include?(user)
  end

end

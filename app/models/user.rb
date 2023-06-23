class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  #ゲストログイン機能のユーザー情報を設定してる。
  def self.guest
    find_or_create_by!(name: 'guestuser' ,email: 'guest@example1.com') do |user|
    user.password = SecureRandom.urlsafe_base64
    user.name = "guestuser"
    end
  end

  #ユーザーに紐づく情報を削除する。
  #下のprivetaの中にあるメソッドから指定したデータをとってくる。
  after_update :destroy_unsubscribe_user_info, if: -> { saved_change_to_is_deleted?(from:false,to:true) }

  #アソシエーションを行っている部分
  has_one_attached :profile_image
  has_many :restaurants, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :tags, dependent: :destroy

  #チャットに関するアソシエーションを書いてます
  has_many :user_rooms
  has_many :chats
  has_many :rooms, through: :user_rooms

  #通知機能に関するアソシエーション（通知モデルと紐付けている）
  #自分からの通知
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  #相手からの通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  #フォローした、されたの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy


  #一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  #ユーザーをフォローするためのメソッド
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  #ユーザーのフォローを解除するためのメソッド
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  #特定のユーザーをフォローしているかどうかを判定するためのメソッド
  def following?(user)
    followings.include?(user)
  end

    #is_deletedがfalseならtrueを返すようにしている
  def active_for_authentication?
    super && (is_deleted == false)
  end

  #フォロー通知を作成するメソッド
  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follower'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follower'
      )
      notification.save if notification.valid?
    end
  end

  #バリデーションの設定
    validates :name, presence: true, length: { maximum: 20 }
    validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "例: test@11.comのように入力してください。" }
    validates :user_introduction, length: { maximum: 40 }
    validates :password, length: { maximum: 30 }
    validates :password_confirmation, length: { maximum: 30 }

  #プロフィールイメージの基本設定を行っている
  def get_profile_image(width,height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/unless_user.png')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end


  private

#退会した会員に紐ずく情報を消す作業しています。
  def destroy_unsubscribe_user_info
    unless
      self.restaurants.destroy_all
      self.comments.destroy_all
      self.favorites.destroy_all
      #self.notifications.where(visited_id: self.id).destroy_all
      relationships.destroy_all
      reverse_of_relationships.destroy_all
    end
  end
end

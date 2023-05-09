class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.guest
    find_or_create_by!(name: 'guestuser' ,email: 'guest@example1.com') do |user|
    user.password = SecureRandom.urlsafe_base64
    user.name = "guestuser"
    end
  end
  
  #ユーザーに紐づく情報を削除する。
  after_update :destroy_unsubscribe_user_info, if: -> { saved_change_to_is_deleted?(from:false,to:true) }

  has_one_attached :profile_image
  has_many :restaurants, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy


    #is_deletedがfalseならtrueを返すようにしている
  def active_for_authentication?
    super && (is_deleted == false)
  end

  def get_profile_image(width,height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/unless_user.png')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  private

  def destroy_unsubscribe_user_info
    self.restaurants.destroy_all
    self.comments.destroy_all
    self.favorites.destroy_all
  end
end

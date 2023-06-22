class Restaurant < ApplicationRecord
  #アソシエーション
  has_one_attached :image
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :restaurant_tags, dependent: :destroy
  has_many :tags, through: :restaurant_tags
  has_many :favorited_users, through: :favorites, source: :user
  #通知モデルとのアソシエーション
  has_many :notifications, dependent: :destroy


  #バリデーションの設定
  validates :shop_name, length: { maximum: 30 }
  validates :introduction, length: { maximum: 100 }
  validates :star, presence: true
  
  #並び替え機能
  #カラムの取り出し方を指示する
  scope :latest, -> {order(created_at: :desc)} #desc（降順）
  scope :old, -> {order(created_at: :asc)} #asc（昇順）
  scope :star_count, -> {order(star: :desc)}

  #地図機能
  #フォームで入力された住所から緯度、経度を計算している。
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  #空のデータを消す作業をしている。
  after_destroy :destroy_empty_tag

  #レストラン検索。設定したransackに渡すデータを設定している。
  def self.ransackable_attributes(auth_object = nil) #(auth_object = nil)は省略可。今回は丁寧に全て書いてる。
    ["created_at", "id", "introduction", "shop_name", "updated_at", "user_id"]
  end

  #いいね機能でユーザーがいいねをしているか調べている。
  def favorited_by?(user)
    user.present? && favorites.exists?(user_id: user.id)
  end
  #タグ検索。設定したransackに渡すデータを設定している。
  def self.ransackable_associations(auth_object = nil)
    ["tags"]
  end
  #active strageの画像の大きさを変更できるメソッド。
  def get_image(width,height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/noimage.png')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
      image.variant(resize_to_limit: [width, height]).processed
  end

  #タグコントローラーに渡すメソッドを定義している。
  def save_tag(sent_tags)
    #タグが存在したら、タグの名前を全取得し配列にする。
    current_tags = self.tags.pluck(:name) unless self.tags.nil?

    #取得したタグから送られてきたタグを除いてoldtagする
    old_tags = current_tags - sent_tags

    #送信されてきたタグから現在存在するタグを除いたタグをnewする
    new_tags = sent_tags - current_tags

    #古いタグを削除する。
    old_tags.each do |old|
      old_tag = Tag.find_by(name: old)
      self.tags.delete(old_tag)
      old_tag.destroy! if old_tag.restaurants.empty?
    end

    #新しいタグを保存する
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
    end
    
  end
  #タグに紐づかない情報を探している。
  def destroy_empty_tag
    Tag.where.missing(:restaurant_tags).destroy_all
  end

  #いいね通知を作成するメソッド
  def create_notification_like!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and restaurant_id = ? and action = ? ", current_user.id, user_id, id, 'favorite'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        restaurant_id: id,
        visited_id: user_id,
        action: 'favorite'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  #コメント通知を作成するメソッド
  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_user_ids = Comment.select(:user_id).where(restaurant_id: id).where.not(user_id: current_user.id).distinct
    temp_user_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    # レストランの投稿者がコメントしていないかつ自分以外場合,通知を送る
    if !temp_user_ids.pluck(:user_id).include?(user_id) && current_user.id != user_id
      save_notification_comment!(current_user, comment_id, user_id)
    end
  end
  #実際の通知レコードを作成・保存するためのメソッド
  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      restaurant_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end



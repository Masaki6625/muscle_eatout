Admin.create!(
  email: "admin@111",
  password: "1234567"
)

users = User.create!(
  [
    {email: 'tara@example.com', name: 'たら', user_introduction: '今年はダイエット頑張ります！',  password: 'tara1111', password_confirmation: 'tara1111', profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/tara.png"), filename:"tara.png")},
    {email: 'medaka@example.com', name: 'めだか', user_introduction: '増量中です！よろしくお願いします！',password: 'medaka2222', password_confirmation: 'medaka2222', profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/medaka.jpg"), filename:"medaka.jpg")},
    {email: 'maguro@example.com', name: 'はまち', user_introduction: '今年大会に出ます！',password: 'maguro3333', password_confirmation: 'maguro3333', profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/hamachi.png"), filename:"hamachi.png")},
    {email: 'sanma@example.com', name: 'さんま', user_introduction: '筋トレ初心者です。',password: 'sanma4444', password_confirmation: 'sanma4444', profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sanma.png"), filename:"sanma.png")},
    {email: 'huguta@example.com', name: 'フグタ', user_introduction: 'よろしくお願いします。',password: 'huguta5555', password_confirmation: 'huguta5555', profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/hugu.png"), filename:"hugu.png")}
  ]
)

tara = User.find(1)
medaka = User.find(2)
maguro = User.find(3)
sanma = User.find(4)
huguta = User.find(5)

tags = Tag.create!(
  [
    {name: 'クッキー'},
    {name: 'コーヒー'},
    {name: 'イタリアン'},
    {name: 'お肉'},
    {name: 'ソース'},
    {name: 'ささみ'},
    {name: 'ケーキ'},
  ]
)

cookie = Tag.find(1)
coffee = Tag.find(2)
italy = Tag.find(3)
meat = Tag.find(4)
sauce = Tag.find(5)
checken = Tag.find(6)
cake = Tag.find(7)


Restaurant.create!(
  [
    {shop_name: 'カフェテリア', introduction: '糖質を抑えたクッキーとおいしいコーヒーが飲めました！', star: '3', address: '大坂城', image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/restaurant1.jpg"), filename:"restaurant1.jpg"), user_id: users[0].id },
    {shop_name: 'グローバルカフェテリア', introduction: 'おいしいアイスクリームを食べれました', star: '4' , address: '姫路城', image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/restaurant2.jpg"), filename:"restaurant2.jpg"), user_id: users[1].id },
    {shop_name: 'イタリアン', introduction: '糖質を抑えたパスタを食べることができました！', star: '5' , address: '名古屋城', image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/restaurant7.jpg"), filename:"restaurant7.jpg"), user_id: users[2].id },
    {shop_name: 'リンコントロ', introduction: 'おいしいイタリアンをいただけました', star: '1' , address: '松本城', image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/restaurant8.jpg"), filename:"restaurant8.jpg"), user_id: users[3].id },
    {shop_name: 'ラ・カーサミーア', introduction: '理由を話したらソースなどは油を使わず、メインもお塩だけで作ってくださいました！', star: '5' , address: '岐阜城', image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/restaurant9.jpg"), filename:"restaurant9.jpg"), user_id: users[4].id },
    {shop_name: '七福神', introduction: 'ささみを丸ごと焼いたメニューがありました。', star: '4' , address: '小田原城', image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/restaurant6.jpg"), filename:"restaurant6.jpg"), user_id: users[4].id }
  ]
)

Restaurant.find(1).tags << [ cookie, coffee ]
Restaurant.find(2).tags << [ coffee, cake ]
Restaurant.find(3).tags << [ italy, coffee]
Restaurant.find(4).tags << [ meat, sauce ]
Restaurant.find(5).tags << [ checken, sauce ]
Restaurant.find(6).tags << [ checken, meat, sauce ]

# Restaurant.find(1).user = tara
# Restaurant.find(2).user = medaka
# Restaurant.find(3).user = maguro
# Restaurant.find(4).user = sanma
# Restaurant.find(5).user = huguta
# Restaurant.find(6).user =
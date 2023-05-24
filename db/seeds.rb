Admin.create!(
  email: "admin@111",
  password: "1234567"
)

users = User.create!(
  [
    {email: 'tara@example.com', name: 'たら', user_introduction: '今年はダイエット頑張ります！', password: 'tara@11.com', profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/tara.png"), filename:"tara.png")},
    {email: 'medaka@example.com', name: 'めだか', user_introduction: '増量中です！よろしくお願いします！', password: 'medaka@22.com', profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/medaka.jpg"), filename:"medaka.jpg")},
    {email: 'maguro@example.com', name: 'はまち', user_introduction: '今年大会に出ます！', password: 'maguro@33.com', profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/hamachi.png"), filename:"hamachi.png")},
    {email: 'sanma@example.com', name: 'さんま', user_introduction: '筋トレ初心者です。', password: 'sanma@44.com', profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sanma.png"), filename:"sanma.png")},
    {email: 'huguta@example.com', name: 'フグタ', user_introduction: 'よろしくお願いします。', password: 'huguta@55.com', profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/huguta.png"), filename:"huguta.png")}
  ]
)

Restaurant.create!(
  [
    {shop_name: 'カフェテリア', introduction: '糖質を抑えたクッキーとおいしいコーヒーが飲めました！', tag: 'コーヒー', star: '3', address: '大坂城', image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/restaurant1.jpg"), filename:"restaurant1.jpg"),　user_id: users[0].id },
    {shop_name: 'グローバルカフェテリア', introduction: 'おいしいアイスクリームを食べれました', tag: 'アイス', star: '4' , address: '姫路城', image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/restaurant2.jpg"), filename:"restaurant2.jpg"), user_id: users[1].id },
    {shop_name: 'イタリアン', introduction: '糖質を抑えたパスタを食べることができました！', tag: 'パスタ', star: '5' , address: '名古屋城', image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/restaurant3.jpg"), filename:"restaurant3.jpg"), user_id: users[2].id },
    {shop_name: 'リンコントロ', introduction: 'おいしいイタリアンをいただけました', tag: 'イタリアン', star: '1' , address: '松本城', image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/restaurant4.jpg"), filename:"restaurant4.jpg"), user_id: users[3].id },
    {shop_name: 'ラ・カーサミーア', introduction: '理由を話したらソースなどは油を使わず、メインもお塩だけで作ってくださいました！', tag: 'ダイエット', star: '5' , address: '岐阜城', image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/restaurant5.jpg"), filename:"restaurant5.jpg"), user_id: users[4].id },
    {shop_name: '七福神', introduction: 'ささみを丸ごと焼いたメニューがありました。', tag: '大会前', star: '4' , address: '小田原城', image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/restaurant6.jpg"), filename:"restaurant6.jpg"), user_id: users[4].id }
  ]
)

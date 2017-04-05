desc 'gives each contact and user a random avatar color'
task :avatar_colors => :environment do
  contacts_without_color = Contact.where("avatar_color = ?", 0)
  contacts_without_color.each do |contact|
    random_color = Random.rand(12)
    contact.avatar_color = random_color
    contact.save(validate: false)
  end
  users_without_color = User.where("avatar_color = ?", 0)
  users_without_color.each do |user|
    random_color = Random.rand(12)
    user.avatar_color = random_color
    user.save(validate: false)
  end
end
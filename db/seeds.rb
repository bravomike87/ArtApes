require "faker"

puts 'Cleaning database User...'
Profile.destroy_all
User.destroy_all

puts 'Cleaning database Profile...'




puts 'Creating 30 fake Users and associated Profiles ...'
30.times do
  user = User.create!(email: Faker::Internet.email, password: 'topsecret', password_confirmation: 'topsecret')
  Profile.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, user: user)
end
puts 'Finished database Profile!'

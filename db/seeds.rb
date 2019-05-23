require "faker"

puts 'Cleaning all databases ...'

Booking.destroy_all
Artwork.destroy_all
Profile.destroy_all
User.destroy_all

puts 'Creating admin User and associated Profile...'

user = User.create!(email: 'admin@artapes.com', password: 'topsecret', password_confirmation: 'topsecret')
profile = user.profile
profile.first_name = 'first'
profile.last_name = 'last'
profile.address = "Raumerstrasse 11, Berlin"

# avatar_url = "https://image.shutterstock.com/image-vector/blank-avatar-photo-placeholder-flat-260nw-1151124605.jpg"
# profile.remote_avatar_url = avatar_url
profile.save
sleep(1.2) # needed for geocode API

puts 'Creating 20 fake Users and associated Profiles, and 1 Artwork each ...'

index = 0
10.times do
  index = 0 if index > 9
  index += 1
  user = User.create!(email: Faker::Internet.email, password: 'topsecret', password_confirmation: 'topsecret')
  profile = user.profile

  profile.first_name = Faker::Name.first_name
  profile.last_name = Faker::Name.last_name
  # profile.remote_avatar_url = avatar_url
  profile.address = "Raumerstrasse #{index}, Berlin"
  profile.save
  sleep(1.2) # needed for geocode API

  art = Artwork.create!(kind: Faker::Quote.singular_siegler, title: Faker::Games::Pokemon.name, description: Faker::Quote.most_interesting_man_in_the_world, tagline: Faker::Games::Pokemon.move, price: "#{index * 10}", width: 20, height: 10, user: user)

  url = "http://lorempixel.com/400/400/abstract/#{index}"
  art.remote_image_url = url
  art.save

  # Booking.create!(status: "available", artwork: art, user: user)
end

puts 'Finished!'


# for images in seed_images :
# curl http://lorempixel.com/400/400/abstract/5/ > db/seed_images/seed_img_5.jpg
# images upload in cloudinary
# index = 0
# 5.times do
#   index += 1
#   Cloudinary::Uploader.upload("db/seed_images/seed_img_#{index}.jpg")
# end


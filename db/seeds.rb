require "faker"

puts 'Cleaning all databases ...'

Booking.destroy_all
Artwork.destroy_all
Profile.destroy_all
User.destroy_all


puts 'Creating 15 fake Users and associated Profiles, Artworks and Bookings ...'

20.times do
  user = User.create!(email: Faker::Internet.email, password: 'topsecret', password_confirmation: 'topsecret')
  Profile.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, user: user)
  art = Artwork.create!(kind: Faker::Quote.singular_siegler, title: Faker::Games::Pokemon.name, description: Faker::Quote.most_interesting_man_in_the_world, tagline: Faker::Games::Pokemon.move, image: "https://images.unsplash.com/photo-1552510373-7a6449943736?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1309&q=80", price: 50, width: 20, height: 10, user: user)
  Booking.create!(status: "available", artwork: art, user: user)
end

puts 'Finished!'


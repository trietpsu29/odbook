# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

require "faker"

puts "Cleaning database..."

User.destroy_all

puts "Creating users..."

users = []

# Avatar files trong:
# app/assets/images/avatars/
#
# ví dụ:
# avatar1.jpg
# avatar2.jpg
# avatar3.jpg
# avatar4.jpg

avatar_files = Dir[Rails.root.join("app/assets/images/avatars/*")]

10.times do |i|
  user = User.create!(
    name: Faker::Name.name,
    email: "user#{i + 1}@example.com",
    password: "password",
    bio: Faker::Lorem.sentence(word_count: 12)
  )

  if avatar_files.any?
    avatar = avatar_files.sample

    user.avatar.attach(
      io: File.open(avatar),
      filename: File.basename(avatar),
      content_type: "image/jpeg"
    )
  end

  users << user
end

puts "Creating posts..."

users.each do |user|
  rand(2..6).times do
    user.posts.create!(
      title: Faker::Lorem.sentence(word_count: 5),
      body: Faker::Lorem.paragraph(sentence_count: 3)
    )
  end
end

puts "Creating follow relationships..."

users.each do |user|
  possible_users = users - [ user ]

  rand(2..5).times do
    target = possible_users.sample

    user.following << target unless user.following.include?(target)
  end
end

puts "Creating likes..."

if defined?(Like)
  Post.find_each do |post|
    rand(0..5).times do
      user = users.sample

      Like.create!(
        user: user,
        post: post
      ) unless post.likes.exists?(user: user)
    end
  end
end

puts "Creating comments..."

if defined?(Comment)
  Post.find_each do |post|
    rand(0..4).times do
      Comment.create!(
        user: users.sample,
        post: post,
        body: Faker::Lorem.sentence
      )
    end
  end
end

puts "Creating demo account..."

demo = User.find_or_create_by!(
  email: "demo@example.com"
) do |user|
  user.name = "Demo User"
  user.password = "password"
  user.bio = "This is a demo account."
end

puts "Done!"
puts "Login:"
puts "Email: demo@example.com"
puts "Password: password"

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

13.times do |i|
  ['a', 'b', 'c', 'd'].each do |letter|
    Card.create!(name: "#{i + 1}#{letter}", point: i + 1, suit: letter)
  end
end

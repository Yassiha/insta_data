require 'json'
require 'csv'

puts '.___                 __              .___       __          '
puts '|   | ____   _______/  |______     __| _/____ _/  |______   '
puts '|   |/    \ /  ___/\   __\__  \   / __ |\__  \\   __\__  \  '
puts '|   |   |  \\___ \  |  |  / __ \_/ /_/ | / __ \|  |  / __ \_'
puts '|___|___|  /____  > |__| (____  /\____ |(____  /__| (____  /'
puts '         \/     \/            \/      \/     \/          \/ '

puts 'SIMPLE RUBY SCRIPT TO MAKE INSTATOUCH EASIER WITH MORE USER FRIENDLY OUTPUTS'

puts '.'
puts '.'
puts 'WARNING: You need to install INSTATOUCH before the use of this script (more info here => https://github.com/drawrowfly/instagram-scraper)'
puts '.'
puts '.'
puts 'TYPE THE EXACT INSTAGRAM USERNAME TO SCRAP..'
user = gets.chomp
puts '.'
puts '.'
puts 'TYPE THE NUMBER OF POSTS TO SCRAP..'
posts = gets.chomp
puts '.'
puts '.'
puts 'TYPE HOW MANY LAST ACTIVE USERS PER POST TO GET..'
input = gets.chomp
puts '.'
puts '.'
puts 'FIRST OUTSIDE CALL'
system("instatouch user #{user} -c #{posts} -f firstOutput -t json -r all")
puts '.'
puts '.'
puts 'OUTSIDE CALL OK!'
puts '.'
puts '.'
puts 'READING FIRST OUTPUT..'
jsontxt = File.read('firstOutput.json')
son = JSON.parse(jsontxt)

shortcode = []
allposts = []

son.each do |post|
  shortcode << post['shortcode']
  allposts << { 'description' => post['description'], 'comments' => post['comments'],
                'likes' => post['likes'], 'date' => post['taken_at_timestamp'] }
end

likers = []
commenters = []
system('touch likers.json')
system('touch comments.json')

puts '.'
puts '.'
puts 'PREPARING SECOND OUTSIDE CALL..'
x = 1
shortcode.each do |code|
  puts "GETTING LIKERS OF POST NUMBER #{x}"
  system("instatouch likers #{code} -f likers -c #{input} -t json -r all")
  sleep 1
  puts "GETTING COMMENTERS OF POST NUMBER #{x}"
  system("instatouch comments #{code} -f comments -c #{input} -t json -r all")
  puts "#{x} / #{shortcode.count}"

  if File.read('likers.json')
    jsontxt = File.read('likers.json')
    son = JSON.parse(jsontxt)
    son.each do |likes|
      likers << { 'username' => likes['username'], 'private' => likes['is_private'], 'verified' => likes['is_verified'] }
    end
  end

  commentstxt = File.read('comments.json')
  if commentstxt.length.positive?
    son2 = JSON.parse(commentstxt)
    son2.each do |comments|
      commenters << { 'username' => comments['owner']['username'], 'comments' => comments['text'],
                      'likes_on_comment' => comments['likes'], 'responses_on_comment' => comments['comments'] }
    end
  end
  x += 1
end
puts '.'
puts '.'
puts 'OUTPUTS READING OK. PREPARING FINAL OUTPUT'
puts "#{likers.count} users scrapped"
puts "#{commenters.count} commenters scrapped"

# REMOVE DUPLICATE AND INCREMENT COUNT OF LIKES PER USERNAME
likers = likers.inject(Hash.new(0)) { |total, e| total[e] += 1; total }

system("touch #{user}_likers.csv")
system("touch #{user}_commenters.csv")
system("touch #{user}_posts.csv")

CSV.open("#{user}_likers.csv", 'w') do |csv|
  csv << %w[username likes is_private is_verified]
  likers.each do |liker|
    csv << [liker[0]['username'], liker[1], liker[0]['private'], liker[0]['verified']]
  end
end

CSV.open("#{user}_commenters.csv", 'w') do |csv|
  csv << %w[username content likes_on_comment responses_on_comment]
  commenters.each do |commenter|
    csv << [commenter['username'], commenter['comments'],
            commenter['likes_on_comment'], commenter['responses_on_comment']]
  end
end

CSV.open("#{user}_posts.csv", 'w') do |csv|
  csv << %w[description comments likes date]
  allposts.each do |post|
    csv << [post['description'], post['comments'], post['likes'], Time.at(post['date'])]
  end
end

puts '.'
puts '.'
puts 'CLEANING THE MESS'
system('rm likers.json')
system('rm firstOutput.json')
system('rm comments.json')
puts '.'
puts '.'
puts 'FINAL OUTPUT READY'
puts 'CODED BY YassIha'
puts '.'
puts '.'

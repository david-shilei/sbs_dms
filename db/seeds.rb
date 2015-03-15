# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "======= Start seeding ======="

admin = User.create!(username: "Admin", email: "admin@test.com", password: "ca$hc0w!", approved: true, is_admin: true)

file = File.open("#{File.dirname(__FILE__)}/seeds.json")
json = JSON.load(file.read)
json.each do |s|
  school_name, group_names = s
  school = School.create(name: school_name)
  group_names.each do |group_name|
    group = Group.new(name: group_name)
    group.school = school
    group.save!
  end
end

group = Group.all.first
alice = User.create!(username: "Alice", email: "alice@test.com", password: "123456", approved: true, is_admin: false, school_id: group.school_id, group_id: group.id)
group = Group.all.last
bob = User.create!(username: "Bob", email: "bob@test.com", password: "123456", approved: true, is_admin: false, school_id: group.school_id, group_id: group.id)


databases = %w(信用管理科研数据库 星级酒店运营数据库 中国商业人才数据仓库 公共服务与社会组织数据库 上海物流行业发展研究数据库 零售业纠纷案例数据库 国际移民政策与商业研究数据库)
databases.each do |db|
  Category.create!(user_id: alice.id, name: db)
end

puts "======= End seeding ======="
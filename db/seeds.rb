return unless Rails.env.development?

User.find_or_create_by!(email_address: "admin@example.com") do |user|
  user.name = "Admin"
  user.password = "password"
end

school = School.find_or_create_by!(name: "Example School")

def maybe(&block)
  return unless Faker::Boolean.boolean

  block.call
end

def build_student_attrs(overrides = {})
  {
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: maybe { Faker::Internet.email(domain: 'example.com') },
    gender: maybe { Student.genders.keys.sample }
  }.merge(overrides)
end

# randomly sample 3 grade levels and create 10 students for each grade level
grades = (1..12).to_a.sample(3)
grades.each do |grade|
  students = 10.times.map { build_student_attrs(grade_level: grade) }
  school.students.create!(students)
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

student_data = JSON.parse(File.open("#{Rails.root}/db/student_classes.json") { |f| f.read })

student_data["classes"].each do |key, value|
  Course.find_or_create_by(id: key, name: value)
end

student_data["students"].each do |student|
  student_record = Student.find_or_create_by(first_name: student["first"], last_name: student["last"], email: student["email"])
  student["studentClasses"].each do |studentClass|
    StudentCourse.find_or_create_by(student: student_record, course_id: studentClass["id"], grade: studentClass["grade"])
  end
end

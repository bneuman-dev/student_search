module Entities
  class StudentEntity < Grape::Entity
    expose :id
    expose :first_name
    expose :last_name
    expose :email
    expose :gpa
    expose :student_courses, if: { type: :detailed }, using: StudentCourseEntity, as: :courses
  end
end

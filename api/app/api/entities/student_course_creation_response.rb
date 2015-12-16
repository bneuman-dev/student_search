module Entities
  class StudentCourseCreationResponse < Grape::Entity
    expose :course_id
    expose :student_id
    expose :grade
  end
end

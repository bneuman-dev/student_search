module Entities
  class StudentCourseEntity < Grape::Entity
    expose :course_id
    expose :grade
    expose :name
  end
end

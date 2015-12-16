class CreateStudentCourses < ActiveRecord::Migration
  def change
    create_table :student_courses do |t|
      t.integer :student_id
      t.integer :course_id
      t.decimal :grade, scale: 1, precision: 2
      t.timestamps
    end
  end
end

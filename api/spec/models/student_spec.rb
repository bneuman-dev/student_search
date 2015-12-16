require 'rails_helper'

RSpec.describe Student, type: :model do
  let (:student) { Student.create(first_name: "foo", last_name: "bar") }
  
  describe "#gpa" do
    it "returns nil if student has taken no courses" do
      expect(student.gpa).to be_nil
    end

    context "student has taken courses" do
      let (:course) { Course.create(name: "Math") }

      it "returns grade in one course when student has taken just one course" do
        StudentCourse.create(student: student, course: course, grade: 4)
        expect(student.gpa).to eq 4
      end

      it "returns average when student has taken more than one course" do
        course2 = Course.create(name: "Science") 
        course3 = Course.create(name: "English")
        StudentCourse.create(student: student, course: course, grade: 3.5)
        StudentCourse.create(student: student, course: course2, grade: 5.5)
        StudentCourse.create(student: student, course: course3, grade: 3.0)

        expect(student.gpa).to eq 4
      end
         
    end
  end

  describe "#search_by_name" do
    it "returns nothing when no match" do
      result = Student.search_by_name({first_name: "Test", last_name: "Exist"})

      expect(result).to be_empty
    end

    it "returns a Student ActiveRecord relation when no match" do
      result = Student.search_by_name({first_name: "Non", last_name: "Exist"})
      expect(result).to be_a Student::ActiveRecord_Relation
    end

    it "returns correctly when first name matches" do
      match1 = Student.create(first_name: "Jim", last_name: "Albert")
      match2 = Student.create(first_name: "Jim", last_name: "Murphy")
      Student.create(first_name: "Bill", last_name: "Stewart")

      result = Student.search_by_name({first_name: "Jim"})

      expect(result).to_not be_empty
      expect(result).to include match1
      expect(result).to include match2
    end

    it "returns correctly when last name matches" do
      match1 = Student.create(first_name: "Jim", last_name: "Albert")
      match2 = Student.create(first_name: "Tim", last_name: "Albert")
      Student.create(first_name: "Bill", last_name: "Stewart")

      result = Student.search_by_name({last_name: "Albert"})

      expect(result).to_not be_empty
      expect(result).to include match1
      expect(result).to include match2
    end

    it "returns correctly when both names match" do
      match1 = Student.create(first_name: "Jim", last_name: "Albert")
      Student.create(first_name: "Tim", last_name: "Albert")
      Student.create(first_name: "Jim", last_name: "Stewart")

      result = Student.search_by_name({first_name: "Jim", last_name: "Albert"})
      expect(result.size).to eq 1
      expect(result).to include match1
    end

    it "returns right number of matches" do
      Student.create(first_name: "Jim", last_name: "Albert")
      Student.create(first_name: "Jim", last_name: "Murphy")
      Student.create(first_name: "Bill", last_name: "Stewart")

      result = Student.search_by_name({first_name: "Jim"})

      expect(result.size).to eq 2
    end

    it "ignores case" do
      match1 = Student.create(first_name: "Jim", last_name: "Albert")

      result = Student.search_by_name({first_name: "jIm"})

      expect(result).to include match1
    end
  end
end

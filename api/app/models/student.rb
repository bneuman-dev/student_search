class Student < ActiveRecord::Base
  has_many :student_courses
  has_many :courses, through: :student_courses

  def gpa
    if student_courses.empty?
      nil
    else
      average = student_courses.sum(:grade) / student_courses.size
      average.round(1)
    end
  end

  def self.search_by_name(name)
    if name[:first_name] && name[:last_name]
      self.where("lower(first_name) = ? and lower(last_name) = ?", 
        name[:first_name].downcase, name[:last_name].downcase)
    elsif name[:first_name]
      self.where("lower(first_name) = ?", name[:first_name].downcase)
    elsif name[:last_name]
      self.where("lower(last_name) = ?", name[:last_name].downcase)
    else
      self.none
    end
  end

  def self.details_view
    self.includes(:courses, :student_courses)
  end

  def self.summary_view
    self.includes(:student_courses)
  end
end

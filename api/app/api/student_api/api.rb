eamodule StudentAPI
  class API < Grape::API
    format :json

    rescue_from ActiveRecord::RecordNotFound do |exception|
      error!({ errors: ["record not found"] }, 404)
    end

    rescue_from ActiveRecord::UnknownAttributeError do |exception|
      error!({ errors: [exception.message] }, 422)
    end

    desc 'get details for a given student'  
    get '/students/:id' do
      present Student.details_view.find(params[:id]), with: Entities::StudentEntity, type: :detailed
    end

  
    desc 'basic search by first_name/last_name query params, or return all students if no params'
    params do
      optional :first_name, type: String, desc: "First name for search"
      optional :last_name, type: String, desc: "Last name for search"
    end

    get '/students' do
      if params[:first_name] || params[:last_name]
        students = Student.search_by_name(params)
      else
        students = Student.all
      end

      present students.summary_view, with: Entities::StudentEntity, type: :summary
    end

  
    desc 'add a student'
    params do
      requires :first_name, type: String, desc: "Student first name"
      requires :last_name, type: String, desc: "Student last name"
      optional :email, type: String, desc: "Student email"
    end
  
    post '/students' do
      student = Student.create(params)
      present student, with: Entities::StudentCreationResponse
    end
    
  
    desc 'update a student'
    params do
      optional :first_name, type: String, desc: "Student first name"
      optional :last_name, type: String, desc: "Student last name"
      optional :email, type: String, desc: "Student email"
    end

    put '/students/:id' do
      student = Student.find(params[:id])
      student.update(params)
      present student, with: Entities::StudentEntity, type: :summary
    end


    desc 'add a course record for a student'
    params do
      requires :course_id, type: Integer, desc: "course id"
      requires :grade, type: String, desc: "Course grade"
    end

    post '/students/:student_id/courses' do    
      student_course = StudentCourse.create(params)
      
      if student_course.invalid?
        error!({ errors: student_course.errors.full_messages}, 422)
      end

      present student_course, with: Entities::StudentCourseCreationResponse
    end


    desc 'add a course'
    params do
      requires :name, type: String, desc: "course name"
    end

    post '/courses' do
      
      course = Course.create(params)
      present course, with: Entities::CourseCreationResponse
    end
  end
end

RSpec.describe StudentSearchApi do
  context 'missing route' do
    it 'returns a 404' do
      get '/somemissingjunk'
      expect(response.status).to eq(404)
    end
  end

  context 'GET /students/:id' do
    context 'student does not exist' do
      it 'returns a 404' do
        get '/api/students/2'
        expect(response.status).to eq(404)
      end
    end

    context 'student exists' do
      let(:student) { Student.create!(first_name: "Jim", last_name: "Bond") }

      it 'returns a 200' do 
        get "/api/students/#{student.id}"
        expect(response.status).to eq(200)
      end

      it 'returns detailed view of the student' do
        get "/api/students/#{student.id}"
        student_response = JSON.parse(response.body)

        expect(student_response).to include "first_name"
        expect(student_response).to include "last_name"
        expect(student_response).to include "email"
        expect(student_response).to include "courses"
        expect(student_response).to include "gpa"
        expect(student_response["courses"]).to be_a Array
      end
    end
  end

  context 'GET /api/students' do
    it 'returns 200' do
      get '/api/students'
      expect(response.status).to eq(200)
    end

    it 'returns an empty array when no students exist' do
      get '/api/students/'
      
      expect(JSON.parse(response.body)).to eq []
    end

    it 'returns a non-empty array when students exist' do
      Student.create(first_name: "Exist", last_name: "Ence") 

      get '/api/students'
      
      expect(JSON.parse(response.body)).to_not be_empty
    end

    context 'search with query params' do
      let(:student) { Student.create!(first_name: "Exist", last_name: "Ence") }

      it 'returns an empty array when no match' do 
        get '/api/students?first_name=Bill'
     
        expect(JSON.parse(response.body)).to be_empty
      end

      it 'matches on first name' do 
        get "/api/students?first_name=#{student.first_name}"

        expect(JSON.parse(response.body)).to_not be_empty
        expect(response.body).to include student.first_name
        expect(response.body).to include student.last_name
      end

      it 'matches on last name' do
        get "/api/students?last_name=#{student.last_name}"

        expect(JSON.parse(response.body)).to_not be_empty
        expect(response.body).to include student.first_name
        expect(response.body).to include student.last_name
      end

      it 'matches exclusively on first and last name' do
        Student.create(first_name: "Exist", last_name: "Dance")
        
        get "/api/students?first_name=#{student.first_name}&last_name=#{student.last_name}"
        
        response_body = JSON.parse(response.body)
        expect(response_body).to_not be_empty
        expect(response_body.size).to eq 1
        expect(response_body.first["first_name"]).to eq student.first_name
        expect(response_body.first["last_name"]).to eq student.last_name
      end
    end
  end

  context 'POST /students/' do
    let (:student_info) { { first_name: "Tim", last_name: "Fond", email: "tfond@test.net" } }
    
    it 'returns 400 if missing required params' do
      post "/api/students", {}

      expect(response.status).to eq 400
    end

    it 'returns 422 if invalid params are passed' do
      post '/api/students', student_info.merge({invalid_param: "invalid" })

      expect(response.status).to eq 422
    end

    it 'returns 201 on creating a student' do    
      post "/api/students/", student_info

      expect(response.status).to eq 201
    end

    it 'creates the student correctly' do
      post "/api/students/", student_info

      id = JSON.parse(response.body)["id"]
      student = Student.find(id)

      expect(student.first_name).to eq student_info[:first_name]
      expect(student.last_name).to eq student_info[:last_name]
      expect(student.email).to eq student_info[:email]
    end
  end

  context 'PUT /students/:id' do
    let(:student) { Student.create(first_name: "Old", last_name: "Man") }
    
    it 'returns 200' do
      put "/api/students/#{student.id}", { first_name: "New" }

      expect(response.status).to eq 200
    end

     it 'returns 422 if invalid params are passed' do
      put "/api/students/#{student.id}", {invalid_param: "invalid" }

      expect(response.status).to eq 422
    end

    it 'updates student' do
      put "/api/students/#{student.id}", { first_name: "New" }
      
      student.reload

      expect(student.first_name).to eq "New"
    end
  end

  context 'POST /students/:id/courses/' do
    let(:student) { Student.create(first_name: "Student", last_name: "Teacher") }
    let(:course) { Course.create(name: "Math 101") }

    it 'returns 201' do
      post "/api/students/#{student.id}/courses", { course_id: course.id, grade: 4 }

      expect(response.status).to eq 201
    end

    it 'returns 400 if missing required param' do
      post "/api/students/#{student.id}/courses", { course_id: course.id }

      expect(response.status).to eq 400
    end

    it 'returns 422 if invalid param' do
      post "/api/students/#{student.id}/courses", { course_id: course.id, grade: 4, invalid_param: "invalid" }

      expect(response.status).to eq 422
    end

    it 'returns 422 if student does not exist' do
      post "/api/students/400000/courses", { course_id: course.id, grade: 4}

      expect(response.status).to eq 422
    end

    it 'returns 422 if course does not exist' do
      post "/api/students/#{student.id}/courses", { course_id: 4000000, grade: 4 }

      expect(response.status).to eq 422
    end

    it 'adds the course for the student' do
      post "/api/students/#{student.id}/courses", { course_id: course.id, grade: 4 }

      expect(student.courses).to include course
    end  
  end

  context 'POST /courses' do
    let(:course_info) { { name: "Math 101" } }

    it 'returns 201' do
      post "/api/courses", course_info

      expect(response.status).to eq 201
    end

    it 'returns 400 if missing required param' do
      post "/api/courses", {}

      expect(response.status).to eq 400
    end

    it 'returns 422 if invalid param' do
      post "/api/courses", course_info.merge({ invalid_param: "invalid" })

      expect(response.status).to eq 422
    end

    it 'adds the course' do
      post "/api/courses", course_info

      id = JSON.parse(response.body)["id"]
      course = Course.find(id)

      expect(course.name).to eq course_info[:name]
    end
  end
end

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * 
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    all_in_9 = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 9
    SQL

    DB[:conn].execute(all_in_9)
  end

  def self.students_below_12th_grade
    all_but_12th = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
      SQL

      DB[:conn].execute(all_but_12th)
  end

  def self.first_x_students_in_grade_10(num)
    first_x_students = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT ?
      SQL
      
      DB[:conn].execute(first_x_students, num) 
  end

  def self.first_student_in_grade_10
    first_student = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT 1
      SQL

      DB[:conn].execute(first_student).map do |row|
        new_from_db(row)
      end.first
  end

  def self.all_students_in_grade_X(grade)
    all_student = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL

      DB[:conn].execute(all_student, grade)
  end






end

class Student
  attr_accessor :id, :name, :grade

  def initialize(id: nil, name: nil, grade: nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.new_from_db(row)
    self.new(id: row[0], name: row[1], grade: row[2])
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    all_array = []
    rows = DB[:conn].execute("SELECT * FROM students")
    rows.each do |row|
      all_array << self.new_from_db(row)
    end
    return all_array
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    row = DB[:conn].execute("SELECT * FROM students WHERE name = (?)", name)[0]
    student = self.new_from_db(row)
    return student
  end

  def self.count_all_students_in_grade_9
    return DB[:conn].execute("SELECT * FROM students WHERE grade = 9")
  end

  def self.students_below_12th_grade
    return DB[:conn].execute("SELECT * FROM students WHERE grade = 9 OR grade = 10 OR grade = 11")
  end

  def self.first_X_students_in_grade_10(x)
    return DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT (?)", x)
  end

  def self.first_student_in_grade_10
    student = nil
    row = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1")[0]
    student = self.new_from_db(row)
    return student
  end

  def self.all_students_in_grade_X(x)
    return DB[:conn].execute("SELECT * FROM students WHERE grade = (?)", x)
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
end

# Discussion 2
Due: 11 September 2020, 11:59pm EDT (No late submissions will be accepted)

Points: 100 public

## Introduction

We will be implementing a few simple functions and a larger class to test your knowledge on code blocks and regular expressions!  You can review the content of the discussion in [notes.rb](notes.md), which includes the topics and examples from the discussion video.

### Testing & Submitting

You will submit this project to [Gradescope](https://www.gradescope.com/courses/171498/assignments/661477).  You may only submit the **disc2.rb** file.  To test locally, run `ruby test/public/public.rb`.

## Part 1: Simple functions

#### `evens_string(hash)`

- **Type**: `(Hash) -> String`
- **Description**: Given a hash map consisting of arbitrary keys mapping to ints, return a string with only those values that are divisible by 2. Use a code block to iterate through the hash.
- **Examples**:
  ```ruby
  hash = {"one"=>1, "two"=>2, "three"=>3, "four"=>4}
  evens_string(hash)   # returned value should be "24"
  ```

#### `map_w_code_block(arr)`

- **Type**: `(Array) -> Array`
- **Description**: Given an array, if a code block is provided return an array where each element has been processed by the code block. If no code block if provided, increment all elements by 1
- **Examples**:
  ```ruby
  a = [1,2,3,4]
  map_w_code_block(a) {|x| x*2} # output is [2,4,6,8]
  map_w_code_block(a)           # output is [2,3,4,5]
  ```

#### `time_teller(time_str)`

- **Type**: `(String) -> String`
- **Description**: Given the provided time string, check that it is valid using a regular expression. If it is valid, return a string with the hour and time (see example). Otherwise, return "Invalid". Times are defined in the following way:
    1. A 2 digit hour (from 01 to 12)
    2. A 2 digit minute (from 00 to 59)
    3. A 2 digit second (from 00 to 59)
    4. A two letter indication : A.M., P.M.  
- **Examples**:
  ```ruby
  time_str = "12:37:59 P.M."
  time_teller(time_str) # "It is 12 P.M."
  time_str = "01:02:14 A.M."
  time_teller(time_str) # "It is 1 A.M."
  time_str = "15:19:06"
  time_teller(time_str) # "Invalid"
  time_str = "12:14 A.M."
  time_teller(time_str) # "Invalid"
  ```
- **Considerations**: Even if the time is 12:59:59 P.M., you should still be returning "It is 12 P.M."
That is, we don't care about the minutes or seconds other than to ensure they're present in the valid string.

## Part 2: 330 `Grader` Class

There are so many students in 330, we have a program that easily adds students in and updates their grades to make it easier. You're going to help us do it!

#### `initialize(filename)`

- **Type**: `(String) -> _`
- **Description**: Given a filename consisting of input about your grades, store information about students. Grades are listed line by line with the student's first and last name (start with a capital letter, followed by any number of lowercase letters), a comma, and then their grade (a number from 0 to 100, inclusive)
Sometimes, we screw stuff up in the data entry. Instead of fixing it, we do it correctly later on in the file, so it's up to you to make sure you ignore all lines that are improperly formed.
- **Examples**:
  Given the file
  ```
  Anwar Mamat, 95
  David Van Horn, 95
  Ta Name, 65
  Student Name, 114
  Another Student: 92
  ```
  you should have grade information for `Anwar Mamat` and `TA Name` only! We reject `David Van Horn` (:() because his name isn't to our specs, `Student Name`, because their grade is invalid, and `Another Student`, because the line is not well-formed (`:` instead of `,`).

#### `add_extra_credit()`

- **Type**: `() -> _`
- **Description**: Sometimes we gain a sudden burst of love for our students and decide to give them all some extra credit. We'll either give everyone some points, apply a curve, or dock everyone's points :smiling_imp: But, we do this on a whim based on how we're feeling by using a code block. It's up to you to update everyone's grades using this code block.
- **Examples**: Using the same file from above:
  ```ruby
  add_extra_credit {|x| x+4}
  # Anwar Mamat now has a 99
  # Ta Name now has a 70
  ```

#### `get_grade_for_student(student_name)`

- **Type**: `(String) -> Integer`
- **Description**: Given a student's name, return their grade. If the student doesn't exist, return nil.
- **Examples**:
  ```ruby
  get_grade_for_student("Ta Name")         # 70
  get_grade_for_student("Another Student") # nil
  ```

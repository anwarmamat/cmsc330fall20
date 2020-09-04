# Discussion 1
Due: 4 September 2020, 11:59pm EDT (No late submissions will be accepted)

Points: 100 public

## Introduction

We will be implementing a simple database using Ruby data structures to store the data.  A database can contain an arbitrary number of tables. Each table will contain tuples of size *n*, where *n* is the number of columns in the table.  Through a series of discussion exercises each week, we will improve upon our simple database.  This week we will create a database representation that will implement some basic functionality.  The class `Tuple` represents and entry in a table.  The class `Table` represents a collection of tuples.

### Testing & Submitting

You will submit this project to [Gradescope](https://www.gradescope.com/courses/171498/assignments/644881).  You may only submit the **disc1.rb** file.  To test locally, run `ruby test/public/public.rb`.

## Part 1: `Tuple`

A `Tuple` represents a single entry, in a table.  The methods below will be implemented in the `Tuple` class in [disc1.rb](src/disc1.rb).

#### `initialize(data)`

- **Type**: `(Array) -> _`
- **Description**: Given an array of values for the tuple, store them in the `Tuple` object in any way you would like.  You should perform any initialization steps for the `Tuple` instance here.  The return value of this function does not matter.
- **Examples**:
  ```ruby
  t = Tuple.new(["a", 1, "b", 2])
  t = Tuple.new([])                # Tuples may be empty 
  ```

#### `getSize()`

- **Type**: `() -> Integer`
- **Description**: Return the number of entries in the `Tuple`.
- **Examples**:
  ```ruby
  t = Tuple.new(["a", 1, "b", 2])
  t.getSize()                      # Returns 4
  u = Tuple.new([])
  u.getSize()                      # Returns 0
  ```

#### `getData(index)`

- **Type**: `(Integer) -> Object`
- **Description**: Return the data at a particular index of a `Tuple` (indexed starting at 0).  If the provided index exceeds the largest index in the tuple, return `nil`.
- **Assumptions**: `index` is non-negative.
- **Examples**:
  ```ruby
  t = Tuple.new(["a", 1, "b", 2])
  t.getData(0)                     # Returns "a"
  t.getData(4)                     # Returns nil
  ```

#### `self.getNumTuples(n)`

- **Type**: `(Integer) -> Integer`
- **Description**: Return the number of `Tuple`s of size `n` that have ever been created.  Hint: you should use a static variable to keep track of this.
- **Examples**:
  ```ruby
  Tuple.getNumTuples(3)         # Returns 0
  t = Tuple.new(["a", 1, "b"])
  t = Tuple.new(["a", 1, "b"])
  Tuple.getNumTuples(3)         # Returns 2
  t = Tuple.new([3])
  Tuple.getNumTuples(3)         # Returns 2
  ```

## Part 2: `Table`

A `Table` represents a collection of tuples.  The methods below will be implemented in the `Table` class in [disc1.rb](src/disc1.rb).

#### `initialize(column_names)`

- **Type**: `(Array) -> _`
- **Description**: Given an array of column names for the `Table`, store them in the object in any way you would like. You should perform any initialization steps for the `Table` instance here.  The return value of this function does not matter.
- **Examples**: 
  ```ruby
  t = Table.new(["c0", "c1", "c2"])
  t = Table.new([])
  ```

#### `insertTuple(tuple)`

- **Type**: `(Tuple) -> boolean`
- **Description**: Insert a `Tuple` into the `Table`.  Note that the number of entries in the `Tuple` must match the number of columns in the `Table`.  If this is not the case, make no changes to the `Table` and return `false`.  If the sizes match, insert the `Tuple` and return `true`.
- **Examples**:
  ```ruby
  table = Table.new(["a", "b"])
  x = Tuple.new([0, 1])
  y = Tuple.new([3, "y"])
  z = Tuple.new([1, 2, 3])

  table.insertTuple(x)  # Returns true
  table.insertTuple(y)  # Returns true
  table.insertTuple(z)  # Returns false (sizes do not match)
  ```

#### `getSize()`

- **Type**: `() -> Integer`
- **Description**: Return the number of `Tuple`s in the table.
- **Examples**:
  ```ruby
  table = Table.new(["a", "b"])
  table.getSize()                # Returns 0
  x = Tuple.new([0, 1])
  table.getSize()                # Returns 1
  ```

#### `selectTuples(column_names)`

- **Type**: `(Array) -> Table`
- **Description**: Return a new `Table` instance which is the same as the existing one, but only with the requested columns.  Hint: to find the index of an element in an array, use `arr.index(element)`.  This function should NOT modify the current table; rather, create a new one.
- **Assumptions**: `column_names` does not include any column names which are not present in the table (i.e. all queries are valid).
- **Examples**:
  ```ruby
  table = Table.new(["a", "b", "c"])
  x = Tuple.new([0, 1, 2])
  y = Tuple.new(["x", "y", "z"])
  table.insertTuple(x)
  table.insertTuple(y)
  # The table currently looks like this:
  #   a  |  b  |  c  
  # -----+-----+-----
  #   0  |  1  |  2  
  #  "x" | "y" | "z" 

  table2 = table.selectTuples(["a, c"])
  # The call above should return a NEW table that looks like this:
  #   a  |  c  
  # -----+-----
  #   0  |  2  
  #  "x" | "z" 
  ```

#### `getTuples()`

- **Type**: `() -> Array`
- **Description**: Return an array of the `Tuple`s present in the `Table`.
- **Examples**:
  ```ruby
  table = Table.new(["a", "b", "c"])
  table.getTuples()                   # Returns []
  x = Tuple.new([0, 1, 2])
  y = Tuple.new(["x", "y", "z"])
  table.getTuples()                   # Returns [[0, 1, 2], ["x", "y", "z"]]
  ```

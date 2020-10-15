# We will be implimenting a simple database table using Ruby data structures to store the data.
# The class Tuple represents an entry in a table.
# The class Table represents a collection of tuples.

class Tuple
    # A static Hash (map) and a tupleCounter. The counter keeps track of the tuple objects created when we call
    # intialize() or Tuple.new(data). The Hash keeps track of keys and values just like java's HAshmap
    # No multiple keys can be present and a key can only change its value.
    @@map = Hash.new(0) # A Hash
    @@tupleCount = 0
    attr_reader :data
    # data is an array of values for the tuple
    def initialize(data)
        @data = data
        @@tupleCount += 1
        if @@map[@data.length()] == 0
            @@map[@data.length()] = 1
        else
            @@map[@data.length()] += 1
        end
    end

    # This method returns the number of entries in this tuple
    def getSize()
        @data.length()
    end

    # This method returns the data at a particular index of a tuple (0 indexing)
    # If the provided index exceeds the largest index in the tuple, nil should be returned.
    # index is an Integer representing a valid index in the tuple.
    def getData(index)
        index < getSize() ? @data[index] : nil
    end

    # This method should return the number of tuples of size n that have ever been created
    # hint: you should use a static variable
    # hint2: a hash can be helpful (though not strictly necessary!)
    def self.getNumTuples(n) 
        @@map[n]    
    end
end

class Table
    # column_names is an Array of Strings
    attr_reader :hash
    def initialize(column_names)
        @column_names = column_names
        @tableCount = 0  # number of tuples in the table
        @tupleArr = []
        @hash = Hash.new { |hash, key| hash[key] = [] }
        for k in 0...@column_names.size
            @hash[@column_names[k]]
        end
    end

    # This method inserts a tuple into the table.
    # Note that tuples inserted into the table must have the right number of entries
    # I.e., the tuple should be the size of column_names
    # If the tuple is the correct size, insert it and return true
    # otherwise, DO NOT insert the tuple and return false instead.
    # tuple is an instance of class Tuple declared above.
    def insertTuple(tuple)
        if @column_names.size == tuple.getSize
            i = 0
            @tupleArr << tuple  # store all the correct tuples in this array, so that is can be
            # returned in the getTuples method
            while i < tuple.getSize
                @hash[@column_names[i]].push(tuple.getData(i))
                i += 1
            end
            @tableCount += 1
            return true
        else
            false
        end
    end
    
    # This method returns the number of tuples in the table
    def getSize
        @tableCount
    end

    def setSize(i)
        @tableCount = i
    end

    # This method selects columns from the table, equivalent to a SQL `select column_names from table` query.
    # This should return a new table that is identical in structure to this one,
    # except only including the columns listed in the `column_names` array
    # EXAMPLE:
    #  column_1 | column_2 | column_3 | column_4
    # -------------------------------------------
    #     1     |    2     |     3    |     4    
    #     2     |    3     |     4    |     1    
    #     3     |    4     |     1    |     2      
    #     4     |    1     |     2    |     3    
    # Note that this is a table made up of 4-element tuples
    # selectTuples(["column_1", "column_3"]) should return a table with the structure
    #  column_1 | column_3
    # ---------------------
    #     1     |     3    
    #     2     |     4    
    #     3     |     1      
    #     4     |     2    
    # Notice that we NOW have a table of 2-element tuples
    # hint: to find the index of an element in an array, you can use arr.index(element)
    def selectTuples(column_names)
        newTable = Table.new(column_names)
        arr = nil
        for i in 0...column_names.size
            arr = @hash[column_names[i]]
            if arr != nil
                newTable.hash[column_names[i]] = arr
            end
        end
        if arr != nil
            newTable.setSize(newTable.getSize + arr.size)
        end
        newTable
    end

    # This should return an array of the tuples present in the table
    def getTuples()
        for k in 0...@tableCount
            arr = []
            for i in 0...@column_names.size
                a = @hash[@column_names[i]]
                arr << a[k]
            end
            made = Tuple.new(arr)
            @tupleArr << made
        end
        @tupleArr
    end
end

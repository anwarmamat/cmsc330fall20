require_relative "graph.rb"

class Synsets
    attr_reader :map
# An Hash to store IDs (keys) and Nouns (Arry of strings) (values)
# Invalid line numbers detected when trying to load one or more files into the Synsets (for the Current Synsets Object).
    def initialize
        @map = Hash.new
    end


    def load(synsets_file)
        #file = File.open(synsets_file, "r")
       # fileArr = file.readlines() # Extracts the file into an array of Lines (line by line reading).
        #count = 0 # To track the number of valid lines in each file
        temp = Hash.new # This hash is for the current file. If there are repeated IDs while processing
        #/^id:\s(\d+)\ssynset:\s([\w\.,\-'\/]+)$/
        invalidLines = []
        invalid = 1
        File.readlines(synsets_file).each do |line| line.chomp!
            if line =~ /^id:\s(\d+)\ssynset:\s([\w\.,\-'\/]+)$/
                id = $1 #Expecting the id:number
                id = id.to_i # convert to integer
                if temp[id] == nil && @map[id] == nil
                    temp[id] = "found"
                else
                    invalidLines << invalid # Collates all invalid lines per file
                    invalidLines.sort!
                end
            else
                invalidLines << invalid
                invalidLines.sort!
            end
            invalid += 1
        end
        if invalidLines.empty? # all valid lines in the file
            File.readlines(synsets_file).each do |line| line.chomp!
                line =~ /^id:\s(\d+)\ssynset:\s([\w\.,\-'\/]+)$/
                id = $1 #Expecting the id:number
                id = id.to_i # convert to integer
                nouns = $2 #the synsets (comma spaced nouns)
                noCommas = nouns.split(/,/) #returns an array of strings without commas
                @map[id] = noCommas
            end
            return nil
        else
            invalidLines
        end
    end

    def addSet(synset_id, nouns)
        if synset_id < 0 || nouns.empty? || nouns == nil || synset_id == nil || @map[synset_id] != nil
            return false
        else
            @map[synset_id] = nouns
            true
        end
    end

    def lookup(synset_id)
        @map[synset_id] != nil ? @map[synset_id] : []
    end

    def findSynsets(to_find)
        if to_find.is_a?(String)
            findHelper(to_find)
        elsif to_find.is_a?(Array)
            syn_hash = Hash.new
            to_find.each {|str|
            syn_hash[str] = findHelper(str)
            }
            syn_hash
        else
            nil
        end
    end
end

def findHelper(to_find)
    syn_arr = [] # includes all IDs that have this noun (to_find)
    @map.keys.each {|key|
        if @map[key].include?(to_find)
            syn_arr << key
        end
    }
    syn_arr
end


class Hypernyms
    attr_reader :graph
    def initialize
        #@hyp = Hash.new { |hyp, key| hyp[key] = [] }
        @graph = Graph.new
    end

    def load(hypernyms_file)
        #^from:\s\d+\sto:\s[\d,?]+$
        result = validate(hypernyms_file)
        if result == nil
            file = File.open(hypernyms_file, "r")
            fileArr = file.readlines() # Extracts the file into an array of Lines (line by line reading).
            fileArr.each do|line| line.chomp!
                if line =~ /^from:\s(\d+)\sto:\s([\d,?]+)$/
                    from = $1.to_i # The ID to which all (to array of strings ints) maps to
                    to = $2
                    to = to.split(/,/) #returns an array of string IDs without commas
                    to.collect! {|id| id.to_i} # converts all string IDs to integers
                    #puts to
                    to.each {|hyp_id| addHypernym(from, hyp_id)} # all hyp_ids will point to (->) from
                end
            end
            return nil
        else
            result
        end
    end

    def validate(filename) #validates the entries if there no invalid lines according to Hypernyms format
        #^from:\s\d+\sto:\s[\d,?]+$
       # file = File.open(filename, "r")
        #fileArr = file.readlines() # Extracts the file into an array of Lines (line by line reading).
        invalidLines = []
        invalid = 1

        File.readlines(filename).each do |line| line.chomp!
            if line =~ /^from:\s\d+\sto:\s[\d,?]+$/
                #do nothing

            else
                invalidLines << invalid
            end
            invalid += 1
        end
        if !invalidLines.empty?
            invalidLines.sort!
        else
            nil
        end
    end

    def addHypernym(source, destination)
        if source == destination || source < 0 || destination < 0
            false
        else
            if !@graph.hasVertex?(source)
                @graph.addVertex(source)
            end
            if !@graph.hasVertex?(destination)
                @graph.addVertex(destination)
            end
            if !@graph.hasEdge?(source, destination)
                @graph.addEdge(source, destination)
            end
            true
        end
    end

    
    def lca(id1, id2)
        if !@graph.hasVertex?(id1) || !@graph.hasVertex?(id2)
            nil
        else
            lca_keys = []
            hash1 = @graph.bfs(id1)
            hash2 = @graph.bfs(id2)    
            filterHash = hash1.select {|k| hash2.keys.include?(k) } # select the keys that are present in both hashes
            #puts filterHash
            temp = Hash.new
            filterHash.keys.each { |key|
                temp[key] = hash1[key] + hash2[key]
            }
            temp = temp.sort_by {|k,v| v}.to_h
            min = temp.values.min
            lca_keys = temp.keys.select {|k| temp[k] == min}
            lca_keys
        end
    end
end

class CommandParser
    def initialize
        @synsets = Synsets.new
        @hypernyms = Hypernyms.new
    end

    def parse(command)
        commands = command.split(" ")
        result = {}
        if commands[0] == "load"
            result[:recognized_command] = :load
            if commands.size == 3
                if commands[1] =~ /^[\w\/\-\.]+$/ && commands[2] =~ /^[\w\/\-\.]+$/
                    tempSyn = Synsets.new
                    synLoad = tempSyn.load(commands[1]) # make a temp. Sysnets object to test if it loads good.
                    if synLoad != nil # if we get the invalidLine array as the result of Synload
                        result[:result] = false
                    else
                        tempHyp = Hypernyms.new
                        hypLoad = tempHyp.load(commands[2])
                        if hypLoad != nil # if we get the invalidLine array as the result of Hypload
                            result[:result] = false
                        else
                            badId = false
                            tempHyp.graph.vertices.each {|node| #check the vertices(keys) if they aren't present, if they are not then the load is invalid
                                if !tempSyn.map.keys.include?(node) && !@synsets.map.keys.include?(node)
                                    badId = true
                                end
                            }
                            if badId == true # bad load to tempHyp
                                result[:result] = false
                            else
                                @synsets.load(commands[1])
                                @hypernyms.load(commands[2])
                                result[:result] = true
                            end
                        end
                    end
                else
                    result[:result] = :error
                end
            else
                result[:result] = :error
            end
        elsif commands[0] == "lookup" #very simple look_up commamnd
            result[:recognized_command] = :lookup
            if commands.length == 2 && commands[1] =~ /^\d+$/
                result[:result] = @synsets.lookup(commands[1].to_i)
            else
                result[:result] = :error
            end
        elsif commands[0] == "find" # for only one string
            result[:recognized_command] = :find
            if commands.length == 2 && commands[1] =~ /^[\w\.\-'\/]+$/
                result[:result] = @synsets.findSynsets(commands[1])
            else
                result[:result] = :error
            end
        elsif commands[0] == "findmany"
            result[:recognized_command] = :findmany
            if command.strip =~ /^findmany\s+([\w\.,\s\-'\/]+)$/
                nouns = $1.split(%r{,\s*})
                badWord = false # if findmany <unwanted entries> [nouns]. I don't want unwanted entries
                nouns.each {|word| 
                    if @synsets.findSynsets(word) == []
                        badWord = true
                    end
                }
                if badWord == false
                    result[:result] = @synsets.findSynsets(nouns)
                else
                    result[:result] = :error
                end
            else
                result[:result] = :error
            end
        elsif commands[0] == "lca"
            result[:recognized_command] = :lca
            if commands.length == 3 && commands[1] =~ /^\d+$/ && commands[2] =~ /^\d+$/
                id1 = commands[1].to_i
                id2 = commands[2].to_i
                if @hypernyms.graph.hasVertex?(id1) && @hypernyms.graph.hasVertex?(id2)
                    result[:result] = @hypernyms.lca(id1, id2)
                else
                    result[:result] = :error
                end
            else
                result[:result] = :error
            end
        else
            result[:recognized_command] = :invalid
        end
        result  
    end
end

require_relative "wordnet.rb"

def parseError(cmd, reason)
    puts "Error parsing #{cmd}: #{reason}"
end

puts "Wordnet interactive shell."

parser = CommandParser.new

while true do
    print "wordnet> "
    $stdout.flush
    input = gets
    if !input || input.strip.downcase == "exit"
        puts "Goodbye"
        break
    end
    next if (input.strip.split.length == 0)
    begin
        output = parser.parse(input.strip)
        #if (output[:recognized_command] 
        cmd = output[:recognized_command]
        result = output[:result]
        if result == :error
            puts "#{cmd.capitalize}: Error"
            next
        end
        case cmd
        when :invalid
            puts "Error: Invalid command"
        when :load
            # success
            if result 
                puts "Load succeeded"
            else
                puts "Load failed"
            end
        when :lookup
            if result == []
                puts "Lookup: Nothing found"
            else 
                puts "Lookup result:"
                puts result
            end
        when :find
            if result == []
                puts "Find: Nothing found"
            else 
                puts "Find result: "
                puts result
            end
        when :findmany
            if result == []
                puts "Findmany: Nothing found"
            else 
                puts "Findmany result: "
                result.each do |k, v|
                    print "#{k}: "
                    if v == []
                        puts "not found"
                    else
                        puts v
                    end
                end
            end
        when :lca
            if result == nil 
                puts "Lca: No least common ancestor"
            else 
                puts "Least common ancestor: "
                puts result
            end
        end

    rescue => e
        puts "Caught error: "
        puts "\t#{e}"
    end
    
end


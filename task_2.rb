#start time the script
T1 = Time.now
#constant variable
SYMBOLS = ARGV[0]
MUTEX1 = Mutex.new

#deleting lines containing user-entered characters from a file
def remove_line(file)
    lines = File.readlines(file)
    size1 = lines.size
    #remove the line if it contains the specified characters
    lines.delete_if {|line| line.include? SYMBOLS}
    size2 = lines.size
    #overwrite the file
    File.open(file, "w+") do |file|
        lines.each do |record|
            file.puts record
        end
    end
    #number of remove lines
    size1-size2
end

#collect data file names into an array
my_files = Dir.glob("*.[txt]*").delete_if { |name| name == 'result.txt' }

threads = []
#unionig all files into one
File.open("result.txt", "w+") {|result|
    my_files.map do |file| 
        #split task into threads
        threads << Thread.new do 
            #checking if the file needs to be edited
            unless SYMBOLS.nil? 
                num_remove_line = remove_line(file)
                puts "Number of lines deleted from '#{file}': #{num_remove_line}" if num_remove_line>0
            end
            MUTEX1.synchronize do
                result.puts IO.read(file)
            end
         end
    end 
threads.each(&:join) }

#script execution time
puts "Runtime: #{Time.now - T1} seconds"
#connect gems (libraries)
require 'mysql2'

#constant variable
MUTEX1 = Mutex.new
FILE = ARGV[0]

#connection to the created database
client = Mysql2::Client.new(:host => "localhost", :username => "test_EY", :password=>"12345678",:database => "test_ey")

if ARGV[0].nil?
    puts "You need to enter the filename when running the script"
elsif Dir.glob("*.[txt]*").include?(ARGV[0])
    #get an array of all records in the file
    lines = File.readlines(ARGV[0])
    i=0
    lines.each do |line|
        i+=1
        puts "Import: #{i}"
        #replace '||' with ','
        new_line = line.gsub("||", ',')
        #convert string to array
        new_line = new_line[0...-2].split(",")
        #using an sql query, we enter data into the table
        client.query("INSERT INTO generated_data(date,latin_record,russian_record,integer_number,float_number) 
                      VALUES ('#{new_line[0]}' ,'#{new_line[1]}' ,'#{new_line[2]}', #{new_line[3]},#{new_line[4]})")
        puts "Remainder: #{lines.size - i}"
    end 
else 
    puts "File with name '#{ARGV[0]}' not found"
end

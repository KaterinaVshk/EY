#connect gems (libraries)
require 'date'

#constants and global variables
START_DATE = Date.today.prev_year(5)
TODAY = Date.today
MUTEX1= Mutex.new
$index_file = 0

#returns the generated string of the desired format
def generate_string()
  date = rand(START_DATE..TODAY).strftime("%d.%m.%Y")
  #concatenate all Latin characters and generate 10 Latin characters
  latin_symbols = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten 
  latin_string = (0...10).map { latin_symbols[rand(latin_symbols.length)] }.join
  #concatenate all Russian characters and generate 10 Russian characters
  russian_symbols =  [('а'..'я'), ('А'..'Я')].map(&:to_a).flatten
  russian_string = (0...10).map { russian_symbols[rand(russian_symbols.length)] }.join
  #generate a positive even number within the required limits
  integer_number = -1
  until integer_number.even? 
    integer_number = rand(1..100000000)
  end
  #generate decimal number
  decimal_number = rand(1.0..20.0).round(8)
  #return the string in the desired form
  "#{date}||#{latin_string}||#{russian_string}||#{integer_number}||#{decimal_number}||"
end    

#creates and completes a file
def generate_file(i)
  $index_file+=1
    File.open("file#{$index_file}.txt", "w+") do |file|
      puts "Generation file: file#{$index_file}.txt"
      #split the generation into threads (10 threads)
      threads=[]
      10.times do
        threads << Thread.new do 
          10000.times do
            #generate string and write to file 
            record = generate_string()
            MUTEX1.synchronize do
              file.puts record
            end
          end
        end
      end
    threads.each(&:join) 
    end
  puts "file#{$index_file}.txt - generated"
end

#causes file creation(100 times)
100.times do |i|
      generate_file(i)
end


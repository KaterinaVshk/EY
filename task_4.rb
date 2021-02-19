#connect gems (libraries)
require 'mysql2'

#connection to the created database
client = Mysql2::Client.new(:host => "localhost", :username => "test_EY", :password=>"12345678",:database => "test_ey")

result = client.query('CALL mediana_and_sum()')
p result.first
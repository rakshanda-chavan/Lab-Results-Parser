class Parser
	require_relative 'LaboratoryTestResult'				
	attr_accessor :path

  def initialize(path)
    @path = path
  end
  
  def mapped_results
  	res = []						#array to store lines of the file
  	results = []					#array to store objects of the LaboratoryTestResult class
  	index = 0						#variable to store the line number
  	prev_index = 1					#variable to store the previous index of the result in text file
  	code = ''						#variables to store the code, result, format and comment
    result = ''
    format = ''
    comment = ''
  	File.open(path) do |f|
  		f.each_line do |line|
    	res << line.gsub(/\s+/m, ' ').strip.split('|')      	#split each line using the | as delimeter to get code and result values
  		end														#used gsub to remove all the extra space and tabs from the string
	end

	len = res.length()											#getting number of lines present in the file.

	res.each do |line| 											#looping through the lines in the file
		index = index + 1									
    	if line[1].to_i > prev_index.to_i then					#When the index is changed/incremented the lines with the previous index are inserted into the LaroratoryTestResult class
    		results << LaboratoryTestResult.new(code,result,format,comment)
    		prev_index = line[1]
    		comment = ''
    	end
  		if line[0] == 'OBX' 									#we pick the code and result from the line starting with OBX
  			code = line[2]
  			result = line[3]									
  			if result == "#{result.to_f}" || result == "#{result.to_i}" then  #based on the result value we obtained we set the format and modify the result value
  				format = 'float'
  			elsif result == 'NEGATIVE'
  				then format = 'boolean'
  				result = -1.0
  			elsif result == 'POSITIVE'
  				then format = 'boolean'
  				result = -2.0
  			elsif result == 'NIL'
  				then format = 'nil_3plus'
  				result = -1.0
  			elsif result == '+'
  				then format = 'nil_3plus'
  				result = -2.0
  			elsif result == '++'
  				then format = 'nil_3plus'
  				result = -2.0
  			elsif result == '+++'
  				then format = 'nil_3plus'
  				result = -3.0
  			end
  		elsif line[0] == 'NTE'
  				if comment != '' then comment = comment + "," end		#append comma if multiple comments are present
    			comment = comment +line[2]
  			if index == len then
  				results << LaboratoryTestResult.new(code,result,format,comment)
  				comment = ''											
  			end
    		
  		else
    		puts "Error: don't know what to do with line #{line}"		#if unexpected line is found print error
  		end
  	end
  	results.each{|result| p result}										#printing the objects
  
  end
end

file_path = "D:/Semester-2/Project/result.txt"		#path of the text file
parser = Parser.new(file_path)
parser.mapped_results 
class LaboratoryTestResult
	attr_accessor :code, :result, :format, :comment

	def initialize(code,result,format,comment)
      @code = code
      @result = result
      @format = format
      @comment = comment
   	end	

end


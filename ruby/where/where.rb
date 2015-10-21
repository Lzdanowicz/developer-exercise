#Psuedo:
#Take an array of hashes and create a method that iterating through the array, looks for a match with the key values and returns that match.

#1. Iterate through each element of an array which should represent a hash object.
#2. Iterate each hash object to access keys and values.
#3. For every Key evaluate if the key is present in the search options if if is compare the value for that key against the option value with that key.
#4. Push matching objects to array collection.

class Array
	def where(options)
		results = []	
		length = options.length	
		self.each { |x| 
			correct = 0
			x.each { |key, value|	
				if options.has_key?(key) && options[key] == value
					correct +=1
					if correct == options.length
						results << x
					end
				elsif options[key].class == Regexp
					if value =~ options[key]
						correct +=1
						if correct == options.length
							results << x
						end
					end
				end
			} 
		}
		return results
  	end
end

require 'json'
require 'rest-client'
require 'time'
require 'date'
require 'time_diff'
require 'pry'

class FareCalculator
  def calculate_fare(user_trips)
   
    num = user_trips.map do |trip|
      trip.total_amount
    end  
    average = num.inject{ |sum, el| sum + el }.to_f / num.size
    average.round(2)
  end

end
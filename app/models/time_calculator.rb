require 'time'
require 'date'
require 'time_diff'

class TimeCalculator

 def calculate_time(user_trips)
    time_differences = user_trips.map do |trip|
      pickup = trip.tpep_pickup_datetime
      dropoff = trip.tpep_dropoff_datetime
      diff = Time.diff(dropoff, pickup, '%y, %M, %w, %d and %H %N %S') 
    end

    result = time_differences.map { |time| time[:minute] }
    average = result.inject{ |sum, el| sum + el }.to_f / result.size
    average.round(0)
  end
end
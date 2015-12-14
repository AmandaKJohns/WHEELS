class Lyft 
  attr_accessor :cost, :time

  def build_lyft(trip)
    directions = GoogleDirections.new(trip.origin.address, trip.destination.address)
    drive_time_in_minutes = directions.drive_time_in_minutes
    distance_in_miles = directions.distance_in_miles

    self.cost = 3 + 2.15 * distance_in_miles + 0.4 * drive_time_in_minutes
    self.cost = 8 if @cost < 8
    self.cost = '%.2f' % cost.round(2)
    self.time = drive_time_in_minutes
    self
  end
end

# Base Charge $3.00
# Cancel Penalty  $10.00
# Cost Minimum  $8.00
# Cost Per Mile $2.15
# Cost Per Minute $0.40
# Trust And Service Fee $0.00
# Toll Fares  †Varies
module Adapters
  class CabClient

    def connection
      @connection = Adapters::DataConnection.new
    end

    def find_yellow_cabs(trip)
      url_fragment = '2yzn-sicd'
      url = build_cab_url(trip, url_fragment)
      connection.query(url)
    end

    def find_green_cabs(trip)
      url_fragment = 'utt9-dvgj'
      url = build_cab_url(trip, url_fragment)
      connection.query(url)
    end

    def build_cab_url(trip, fragment)
      params = {pickup_longitude: trip.origin.longitude, pickup_latitude: trip.origin.latitude, dropoff_longitude: trip.destination.longitude, dropoff_latitude: trip.destination.latitude}

      url_string = "https://data.cityofnewyork.us/resource/#{fragment}.json?$limit=50000&$where="
        params.each do | attribute, data |
          range1 = data - 0.001
          range2 = data + 0.001
          url_string += "#{attribute}%20%3E%20#{range1}%20AND%20#{attribute}%20%3C%20#{range2}%20AND%20"
        end
      url_string.chomp("%20AND%20")
    end 
    
  end
end
class UserTripsController < ApplicationController

  def new
    if session[:user_id]
      HistoricalTrip.destroy_all
      @user = User.find(session[:user_id])
      @favorite_trips = @user.user_trips.map {|trip| ["#{trip.origin.address} to #{trip.destination.address}", trip.id]}
    end
    render 'welcome'
  end

  def create
    if form_invalid? && params[:trip].size == 0
      flash[:alert] = 'Invalid Entry'
      redirect_to root_path
    else
      set_trip
      total_results = cab_results(@trip)
      if !total_results
        flash[:alert] = "Sorry, there are no records for that trip."
        redirect_to root_path
      else
        total_results.map {|trip| HistoricalTrip.create(trip)} #create historical trips
        redirect_to @trip
      end
    end
  end

  def destroy
    UserTrip.destroy(params[:id])    
    redirect_to my_trips_path
  end

  def show
    @trip = UserTrip.find(params[:id])
    find_cab_cost(HistoricalTrip.all) # return @cost
    find_cab_time(HistoricalTrip.all) # return @time
    uber_results(@trip) #return @uber_ride
    lyft_results(@trip) #return @lyft
  end

  def taxi_data
    render 'taxi_data'
  end

  def subway
    @trip = UserTrip.last
    render 'subway'
  end

  private

  def form_invalid?
    params[:address1].empty? || params[:address2].empty?
  end

  def set_trip
    params[:trip] != "" &&  params[:trip] ? @trip = UserTrip.find(params[:trip]) : @trip = UserTrip.new
    @trip.build_origin(address: params[:address1]) unless @trip.origin
    @trip.build_destination(address: params[:address2]) unless @trip.destination
    @trip.user_id = session[:user_id] if logged_in?
    @trip.save
    @trip
  end

  def cab_results(trip)
    taxi_trip = Adapters::CabClient.new
    yellow_cabs = taxi_trip.find_yellow_cabs(trip)
    green_cabs = taxi_trip.find_green_cabs(trip)
    total_results = yellow_cabs.concat(green_cabs)
    if total_results.count > 0
      return total_results
    else
      nil
    end
  end

  def find_cab_cost(total_results)
    @cost = FareCalculator.new.calculate_fare(total_results)
  end

  def find_cab_time(total_results)
    @time = TimeCalculator.new.calculate_time(total_results)
  end

  def uber_results(trip)
    uber_trip = Adapters::UberClient.new   
    uber_results = uber_trip.build_uber_url(trip)
    @uber_ride = uber_trip.format_uber_results(uber_results)
  end

  def lyft_results(trip)
    @lyft = Lyft.new.build_lyft(trip) 
  end

end



class ReservationsController < ApplicationController
before_filter :get_reservation, only: [:show, :edit, :update, :destroy]
before_filter :get_restaurant
# before_filter :authenticate_owns_reservations

  def index
    @reservations = current_user.reservations # => so only the current_user can see their own reservations
  end

  def show
   @reservations = Reservation.where(user_id: current_user.id)
  end

  def edit
  end

  def new
    @reservation = Reservation.new
  end

  def create
    # @reservation = @restaurant.reservations.build(reservation_params)
    @reservation = Reservation.new(reservation_params)
    @reservation.user_id = current_user.id
    @reservation.restaurant_id = @restaurant.id

    seats_reserved = @restaurant.reservations.where("date > ? and date < ?", @reservation.date.beginning_of_hour, @reservation.date.beginning_of_hour + 1.hour).map(&:party_size).sum

    # seats_reserved = @restaurant.reservations
    #                                   .where("date > :start_time AND date < :end_time", {
    #                                     start_time: @reservation.date,
    #                                     end_time: @reservation.date + 1.hours
    #                                   }).map(&:party_size).sum


    seats_available = @restaurant.capacity - seats_reserved

    if @reservation.party_size >= seats_available
      flash[:alert] = "This reservation cannot be made."
      render :new
    else
      @reservation.save
      flash[:notice] = "Your reservation has been created."
      redirect_to restaurants_path
    end
  end

  def update

    if @reservation.update_attributes(reservation_params)
      redirect_to restaurant_reservation_path(@restaurant, @reservation)
    else
      render :new
    end
  end

  def destroy
    @reservation.destroy
      redirect_to restaurant_reservation_path(@restaurant, @reservation)
  end

  private

  # def authenticate_owns_reservations
  #   unless current_user.id == @reservation.user_id
  #     flash[:alert] = "You do not have access to this reservation."
  #     redirect_to '/'
  #   end
  # end

  def reservation_params
    params.require(:reservation).permit(:party_size, :date)
  end

  def get_reservation
    @reservation = Reservation.find(params[:id])
  end

  def get_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end


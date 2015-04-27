class ReservationsController < ApplicationController
before_filter :get_restaurant

  def index
    @reservations = Reservation.all
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def edit
    @reservation = Reservation.find(params[:id])
  end

  def new
    @reservation = Reservation.new
  end

  def create
    @availability = @restaurant.capacity - party_size
    @reservation = Reservation.new(reservation_params)

    if @reservation.save
      redirect_to restaurant_reservation_path(@restaurant, @reservation)
    else
      render :new
    end
  end

  def update
    @reservation = Reservation.find(params[:id])

    if @reservation.update_attributes(reservation_params)
      redirect_to restaurant_reservation_path(@restaurant, @reservation)
    else
      render :new
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
      redirect_to restaurant_reservation_path(@restaurant, @reservation)
  end

  private

  def reservation_params
    params.require(:reservation).permit(:party_size, :date)
  end

  def get_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end


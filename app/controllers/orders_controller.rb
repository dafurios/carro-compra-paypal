class OrdersController < ApplicationController
  before_action :authenticate_user!

  before_action :set_cart, only: [:index, :empty_cart]



  def index
    @cart
    @total = @cart.inject(0) { |total, order| total += order.product.price}
    @cantidad = @cart.pluck(:quantity).count

  end

  def create

    @previous_order = Order.find_by(user_id: current_user.id, product_id: params[:product_id], payed: false)

    if @previous_order.present?
      new_quantity = @previous_order.quantity + 1
      @previous_order.update(quantity: new_quantity)
      redirect_to root_path, notice: "#{@previous_order.product.name} ha sido agregado al carrito"

    else

    @order = Order.new()
    @product = Product.find(params[:product_id])
    @order.product = @product
    @order.price = @product.price
    @order.user = current_user

    if @order.save
      redirect_to root_path, notice: 'El producto ha sido agregado'

    else
      redirect_to root_path, alert: 'El producto NO ha sido agregado'
    end
    end
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.quantity == 1
      if @order.destroy
      redirect_to orders_path, notice: 'Carro Actualizado'
    else
      redirect_to orders_path, alert: 'Error al actualizar el carro'
    end
    elsif @order.quantity > 1
      new_quantity = @order.quantity -= 1
      if @order.save
        redirect_to orders_path, notice: 'Carro Actualizado'
      else
        redirect_to orders_path, alert: 'Error al actualizar el carro'
    end
  end
end

def empty_cart
  @cart = current_user.orders.where(payed: false)
  @cart.destroy_all

  redirect_to orders_path, notice: 'Carro Actualizado'

end

private

def set_cart
@cart = current_user.cart
end


end

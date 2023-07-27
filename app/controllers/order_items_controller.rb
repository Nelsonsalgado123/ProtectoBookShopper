class OrderItemsController < ApplicationController
  before_action :set_order_item, only: %i[show edit update destroy]

  # GET /order_items or /order_items.json
  def index
    @order_items = OrderItem.all
  end

  # GET /order_items/1 or /order_items/1.json
  def show
    # Aquí puedes implementar la lógica para mostrar la vista show.html.erb
    # Por ejemplo, puedes cargar los datos necesarios para mostrar los detalles del carrito.

    # Si ya tienes las variables de instancia @order_items y @total disponibles
    # en la acción `show_cart`, puedes reutilizarlas para mostrar los detalles del carrito.

    # Si no tienes las variables de instancia disponibles, puedes cargar los datos necesarios:
    @order_items = current_cart.order_items
    @total = calculate_total

    # Después, redirige a la vista show.html.erb.
    # Puedes hacer esto directamente en la acción o utilizar `render` si prefieres mantener la URL actual.
    render 'show'
  end

  # GET /order_items/new
  def new
    @order_item = OrderItem.new
  end

  # GET /order_items/1/edit
  def edit
  end

  # POST /order_items or /order_items.json
  def create
    @order_item = OrderItem.new(order_item_params)

    respond_to do |format|
      if @order_item.save
        format.html { redirect_to order_item_url(@order_item), notice: "Order item was successfully created." }
        format.json { render :show, status: :created, location: @order_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def resumen
    # Aquí puedes implementar la lógica para mostrar la vista resumen.html.erb
    # Por ejemplo, puedes cargar los datos necesarios para el resumen.

    # Si ya tienes las variables de instancia @order_items y @total disponibles
    # en la acción `show`, puedes reutilizarlas para mostrar el resumen.

    # Si no tienes las variables de instancia disponibles, puedes cargar los datos necesarios:
    @order_items = current_cart.order_items
    @total = calculate_total

    # Después, redirige a la vista resumen.html.erb.
    # Puedes hacer esto directamente en la acción o utilizar `render` si prefieres mantener la URL actual.
    render 'resumen'
  end

  def update_quantity
    @order_item = OrderItem.find(params[:id])
    new_quantity = params[:quantity].to_i
    @order_item.update(quantity: new_quantity)

    respond_to do |format|
      format.html { redirect_to order_items_url, notice: "Cantidad actualizada correctamente." }
      format.js   # Responder a las solicitudes AJAX con el archivo update_quantity.js.erb
    end
  end

  def complete_purchase
    # Aquí debes implementar la lógica para completar la compra.
    # Puedes acceder a los items del carrito en @order_items.
    # Por ejemplo, puedes reducir las cantidades compradas de los productos en la base de datos.
    # Luego, puedes redirigir a una página de confirmación de compra o agradecimiento.
    # E.g., order_item.product.quantity -= order_item.quantity para reducir las cantidades.
    # No tengo acceso a tu modelo completo, así que la lógica exacta puede variar según tu implementación.
    redirect_to thank_you_path, notice: "Gracias por tu compra. Tu pedido se ha completado exitosamente."
  end

  # PATCH/PUT /order_items/1 or /order_items/1.json
  def update
    respond_to do |format|
      if @order_item.update(order_item_params)
        format.html { redirect_to order_item_url(@order_item), notice: "Order item was successfully updated." }
        format.json { render :show, status: :ok, location: @order_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_items/1 or /order_items/1.json
  def destroy
    @order_item.destroy

    respond_to do |format|
      format.html { redirect_to order_items_url, notice: "Order item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Acción para agregar un producto al carrito
  def add_to_cart
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    # Validar el stock del producto antes de agregarlo al carrito
    if product.quantity >= quantity
      order_item = OrderItem.new(product: product, quantity: quantity, price: product.price, image: product.image)

      if order_item.save
        redirect_to order_items_url, notice: "Producto agregado al carrito."
      else
        redirect_to product_path(product), alert: "No se pudo agregar el producto al carrito."
      end
    else
      redirect_to product_path(product), alert: "Producto agotado. No se puede agregar al carrito."
    end
  end

  def show_cart
    @order_items = current_cart.order_items
    @total = calculate_total
  end
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_item_params
    params.require(:order_item).permit(:product_id, :quantity, :price, :image)
  end

  # Método para obtener el carrito actual
  def current_cart
    @current_cart ||= Cart.first_or_create(user_id: default_user_id)
  end
  def default_user_id
    # Aquí puedes proporcionar el ID del usuario por defecto o lógica para obtenerlo
    # Por ejemplo, si tienes un usuario por defecto con ID 1, puedes retornar 1:
    1
  end

  # Método para calcular el total de la compra
  def calculate_total
    @cart_items.sum { |item| item[:quantity] * item[:price] }
  end

  def complete_purchase
    # Aquí debes implementar la lógica para completar la compra.
    # Puedes acceder a los items del carrito en @order_items.
    # Por ejemplo, puedes reducir las cantidades compradas de los productos en la base de datos.
    # Luego, puedes redirigir a una página de confirmación de compra o agradecimiento.
    # E.g., order_item.product.quantity -= order_item.quantity para reducir las cantidades.
    # No tengo acceso a tu modelo completo, así que la lógica exacta puede variar según tu implementación.

    # Aquí asumo que hay una relación entre los modelos `User` y `Cart`, y que un usuario tiene un carrito (uno a uno o uno a muchos).
    # Si ese es el caso, puedes utilizar algo como esto:
    current_cart.order_items.each do |order_item|
      order_item.product.quantity -= order_item.quantity
      order_item.product.save
    end

    # Luego, puedes vaciar el carrito para completar la compra (esto depende de tu implementación):
    current_cart.order_items.destroy_all

    redirect_to thank_you_path, notice: "Gracias por tu compra. Tu pedido se ha completado exitosamente."
  end

  # Resto de las acciones del controlador...

  private

  # Método para obtener el carrito actual
  def current_cart
    @current_cart ||= Cart.first_or_create
  end

  # Método para calcular el total de la compra
  def calculate_total
    @order_items.sum { |item| item.quantity * item.price }
  end
end

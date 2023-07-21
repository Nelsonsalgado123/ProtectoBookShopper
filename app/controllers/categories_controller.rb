class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # Método para obtener el carrito actual del usuario
  def current_cart
    @current_cart ||= Cart.find_or_create_by(user: current_user)
  end

  # Hacemos el método current_cart disponible como helper para los controladores y vistas
  helper_method :current_cart

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
  end


  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to category_path(@category), notice: "Category was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to category_path(@category), notice: "Category was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path, notice: "Category was successfully destroyed."
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :image)
  end
end

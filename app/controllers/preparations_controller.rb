class PreparationsController < ApplicationController
  before_action :set_preparation, only: %i[ show edit update destroy ]

  # GET /preparations or /preparations.json
  def index
    @preparations = Preparation.all
  end

  # GET /preparations/1 or /preparations/1.json
  def show
  end

  # GET /preparations/new
  def new
    @preparation = Preparation.new
    @preparation.build_dish # For new dish
    @preparation.occasions.build # For new occasions
  end

  # GET /preparations/1/edit
  def edit
  end

  # POST /preparations or /preparations.json
  def create
    # Handle Dish
    dish = if preparation_params[:dish_id].present?
            Dish.find(preparation_params[:dish_id])
    else
            # Ensure `new_dish` is always initialized
            new_dish = Dish.new(
              name: preparation_params[:new_dish_name],
              description: preparation_params[:new_dish_description]
            )

            # Check if `new_dish` is valid
            if new_dish.valid?
              new_dish.save
              new_dish
            else
              # Use `new_dish.errors` safely here
              flash[:alert] = "Dish is invalid: #{new_dish.errors.full_messages.join(', ')}"
              render :new, status: :unprocessable_entity and return
            end
    end

    # Handle Holiday and Occasion
    holiday = if preparation_params[:holiday_id].present?
                Holiday.find(preparation_params[:holiday_id])
    else
                new_holiday = Holiday.new(
                  name: preparation_params[:new_holiday_name],
                  description: preparation_params[:new_holiday_description]
                )
                unless new_holiday.valid?
                  flash[:alert] = "Holiday is invalid: #{new_holiday.errors.full_messages.join(', ')}"
                  render :new, status: :unprocessable_entity and return
                end
                new_holiday.save
                new_holiday
    end

    occasion = Occasion.find_or_create_by!(holiday: holiday)

    # Create Preparation
    @preparation = Preparation.new(preparation_params.except(:new_dish_name, :new_dish_description, :new_holiday_name, :new_holiday_description, :holiday_id))
    @preparation.dish = dish
    @preparation.occasions << occasion

    if @preparation.save
      redirect_to preparations_path, notice: "Preparation successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /preparations/1 or /preparations/1.json
  def update
    # Handle Dish
    dish = if preparation_params[:dish_id].present?
            Dish.find(preparation_params[:dish_id])
    else
            new_dish = Dish.new(
              name: preparation_params[:new_dish_name],
              description: preparation_params[:new_dish_description]
            )

            if new_dish.valid?
              new_dish.save
              new_dish
            else
              flash[:alert] = "Dish is invalid: #{new_dish.errors.full_messages.join(', ')}"
              render :edit, status: :unprocessable_entity and return
            end
    end

    # Handle Holiday and Occasion
    holiday = if preparation_params[:holiday_id].present?
                Holiday.find(preparation_params[:holiday_id])
    else
                new_holiday = Holiday.new(
                  name: preparation_params[:new_holiday_name],
                  description: preparation_params[:new_holiday_description]
                )

                unless new_holiday.valid?
                  flash[:alert] = "Holiday is invalid: #{new_holiday.errors.full_messages.join(', ')}"
                  render :edit, status: :unprocessable_entity and return
                end

                new_holiday.save
                new_holiday
    end

    occasion = Occasion.find_or_create_by!(holiday: holiday)

    # Update Preparation
    if @preparation.update(preparation_params.except(:new_dish_name, :new_dish_description, :new_holiday_name, :new_holiday_description, :holiday_id))
      @preparation.dish = dish
      @preparation.occasions = [ occasion ]

      if @preparation.save
        redirect_to @preparation, notice: "Preparation successfully updated."
      else
        flash[:alert] = "Preparation save failed: #{@preparation.errors.full_messages.join(', ')}"
        render :edit, status: :unprocessable_entity
      end
    else
      flash[:alert] = "Update failed: #{@preparation.errors.full_messages.join(', ')}"
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /preparations/1 or /preparations/1.json
  def destroy
    @preparation = Preparation.find(params[:id])
    @preparation.destroy
    redirect_to preparations_url, notice: "Preparation was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_preparation
      @preparation = Preparation.find(params.require(:id))
    end

    # Only allow a list of trusted parameters through.
    def preparation_params
      params.require(:preparation).permit(
        :dish_id, :new_dish_name, :new_dish_description,
        :holiday_id, :new_holiday_name, :new_holiday_description,
        :backstory, :recipe_long_form, :date_cooked
      )
    end
end

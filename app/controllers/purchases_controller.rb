class PurchasesController < ApplicationController
  respond_to :html, :json

  before_action :authorize
  before_action :set_purchase, only: [:show, :edit, :update, :destroy]
  before_action :set_title, except: [:destroy]

  include BookScoped

  # GET /purchases
  def index
    @purchases = @book.purchases.ordered.page params[:page]
  end

  # GET /purchases/1
  def show
  end

  # GET /purchases/new
  def new
    @purchase = @book.purchases.new
  end

  # GET /purchases/1/edit
  def edit
  end

  # POST /purchases
  def create
    @purchase = @book.purchases.new purchase_params

    @purchase.save
    respond_with @purchase
  end

  # PATCH/PUT /purchases/1
  def update
    update_resource @purchase, purchase_params
    respond_with @purchase
  end

  # DELETE /purchases/1
  def destroy
    @purchase.destroy
    respond_with @purchase, location: book_purchases_url(@book)
  end

  private

    def set_purchase
      @purchase = @resource = Purchase.find params[:id]
    end

    def purchase_params
      params.require(:purchase).permit :provider_id, :requested_at,
        :delivered_at, :lock_version, purchase_commodities_attributes: [
          :id, :commodity_id, :commodity_type, :unit, :quantity, :price, :_destroy
        ]
    end
end

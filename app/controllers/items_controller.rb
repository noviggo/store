class ItemsController < ApplicationController
  respond_to :html, :json, :js

  before_action :authorize
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :set_title, except: [:destroy]

  # GET /items
  def index
    @items = Item.search query: params[:q], limit: request.xhr?
  end

  # GET /items/1
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  def create
    @item = Item.new item_params

    @item.save
    respond_with @item
  end

  # PATCH/PUT /items/1
  def update
    update_resource @item, item_params
    respond_with @item
  end

  # DELETE /items/1
  def destroy
    @item.destroy
    respond_with @item, location: commodities_url
  end

  private

    def set_item
      @item = Item.find params[:id]
    end

    def item_params
      params.require(:item).permit :code, :unit, commodity_attributes: [
        :id, :name, :price, :lock_version
      ]
    end
end

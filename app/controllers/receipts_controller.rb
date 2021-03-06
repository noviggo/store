class ReceiptsController < ApplicationController
  respond_to :html, :json

  before_action :authorize
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]
  before_action :set_title, except: [:destroy]

  include BookScoped

  # GET /receipts
  def index
    @receipts = receipts.ordered.page params[:page]
  end

  # GET /receipts/1
  def show
  end

  # GET /receipts/new
  def new
    @receipt = @book.receipts.new customer_id: params[:customer_id]
  end

  # GET /receipts/1/edit
  def edit
  end

  # POST /receipts
  def create
    @receipt = @book.receipts.new receipt_params

    ask_for_feedback if @receipt.save && @receipt.customer_has_email?
    respond_with @receipt
  end

  # PUT/PATCH /receipts/1
  def update
    update_resource @receipt, receipt_params
    respond_with @receipt
  end

  # DELETE /receipts/1
  def destroy
    @receipt.destroy
    respond_with @receipt, location: book_receipts_url(@book)
  end

  private

    def set_receipt
      @receipt = @resource = Receipt.find params[:id]
    end

    def receipts
      customer ? @book.receipts.by_customer(customer) : @book.receipts
    end

    def customer
      @customer ||= Customer.find params[:customer_id] if params[:customer_id]
    end

    def receipt_params
      params.require(:receipt).permit :customer_id, :issued_at, :lock_version,
        receipt_commodities_attributes: [
          :id, :commodity_id, :quantity, :_destroy, bounds_attributes: [
            :id, :user_id, :notes, :duration, :_destroy, uses_attributes: [
              :id, :item_id, :quantity, :_destroy
            ]
          ]
      ]
    end

    def ask_for_feedback
      if params[:ask_for_feedback]
        feedback = Feedback.create! customer: @receipt.customer, owner: @receipt

        FeedbackMailer.delay.feedback feedback
      end
    end
end

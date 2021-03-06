module InvoicesHelper
  def invoice_commodities
    @invoice.invoice_commodities.new if @invoice.invoice_commodities.empty?

    @invoice.invoice_commodities
  end

  def invoice_number
    @invoice.persisted? ? @invoice.number : @book.next_available_number
  end

  def new_invoice_link options = {}
    link_to_new new_book_invoice_path(@book, customer_id: params[:customer_id]), options
  end
end

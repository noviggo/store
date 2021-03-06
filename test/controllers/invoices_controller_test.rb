require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase

  setup do
    @invoice = invoices :first_sale
    @book = @invoice.book

    login
  end

  test 'should get index' do
    get :index, book_id: @book
    assert_response :success
    assert_not_nil assigns(:invoices)
  end

  test 'should get index filtered by customer' do
    customer = @invoice.customer

    get :index, book_id: @book, customer_id: customer
    assert_response :success
    assert_not_nil assigns(:invoices)
    assert assigns(:invoices).all? { |i| i.customer == customer }
  end

  test 'should get new' do
    get :new, book_id: @book
    assert_response :success
  end

  test 'should create invoice' do
    assert_difference ['Invoice.count', 'InvoiceCommodity.count'] do
      post :create, book_id: @book, invoice: {
        customer_id: customers(:havanna).id,
        issued_at: I18n.l(Time.zone.today),
        invoice_commodities_attributes: [
          { commodity_id: commodities(:candy).id, quantity: '5', price: '12.11' }
        ]
      }
    end

    assert_redirected_to invoice_url(assigns(:invoice))
  end

  test 'should show invoice' do
    get :show, id: @invoice
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @invoice
    assert_response :success
  end

  test 'should update invoice' do
    patch :update, id: @invoice, invoice: { number: '2' }
    assert_redirected_to invoice_url(assigns(:invoice))
  end

  test 'should destroy invoice' do
    assert_difference('Invoice.count', -1) do
      delete :destroy, id: @invoice
    end

    assert_redirected_to book_invoices_url(@book)
  end
end

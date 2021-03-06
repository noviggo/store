require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  include EntitiesTestHelper

  setup do
    @customer = customers :havanna

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:customers)
  end

  test 'should filtered index' do
    get :index, q: @customer.name
    assert_response :success

    customers = assigns :customers
    assert_equal 1, customers.size
    assert_equal @customer.name, customers.first.name
  end

  test 'should filtered index in JSON' do
    xhr :get, :index, q: @customer.name, format: :json
    assert_response :success

    customers = JSON.parse(@response.body)
    assert_equal 1, customers.size
    assert_equal @customer.name, customers.first['name']
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should get new as js' do
    xhr :get, :new
    assert_response :success
    assert_template layout: nil
  end

  test 'should create customer' do
    assert_difference('Customer.count') do
      post :create, customer: {
        birth: I18n.l(Time.zone.yesterday),
        entity_attributes: generic_entity_attributes
      }
    end

    assert_redirected_to customer_url(assigns(:customer))
  end

  test 'should create customer via js' do
    assert_difference('Customer.count') do
      xhr :post, :create, customer: {
        birth: I18n.l(Time.zone.yesterday),
        entity_attributes: generic_entity_attributes
      }
    end

    assert_response :success
    assert_template 'customers/create'
  end

  test 'should show customer' do
    get :show, id: @customer
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @customer
    assert_response :success
  end

  test 'should update customer' do
    patch :update, id: @customer, customer: {
      entity_attributes: { id: @customer.entity.id, name: 'Updated' }
    }
    assert_redirected_to customer_url(assigns(:customer))
  end

  test 'should destroy customer' do
    @customer.invoices.clear
    @customer.receipts.clear

    assert_difference('Customer.count', -1) do
      delete :destroy, id: @customer
    end

    assert_redirected_to customers_url
  end
end

require 'test_helper'

class PurchasesTest < ActionDispatch::IntegrationTest
  include EntitiesTestHelper
  include ItemTestHelper
  include CityTestHelper

  test 'should create a purchase' do
    book = books :cirope_sa_p
    login

    visit new_book_purchase_path(book)
    fill_in_new_purchase

    add_item items(:candy), 1
    add_item items(:chocolate), 2

    assert_difference 'book.purchases.count' do
      assert_difference 'PurchaseItem.count', 2 do
        find('.btn.btn-primary').click
      end
    end
  end

  test 'should remove purchase relations' do
    purchase = purchases :first_purchase

    login

    visit edit_purchase_path(purchase)

    page.find('#purchase_items fieldset:nth-child(1)').hover

    within '#purchase_items fieldset:nth-child(1)' do
      find('a[data-dynamic-form-event="hideItem"]').click
    end

    assert_difference 'purchase.purchase_items.count', -1 do
      find('.btn.btn-primary').click
    end
  end

  test 'should create a new provider' do
    login

    visit new_book_purchase_path(books(:cirope_sa_a))

    add_provider
  end

  test 'should add new item' do
    book = books :cirope_sa_p
    login

    visit new_book_purchase_path(book)
    fill_in_new_purchase

    add_new_item prefix: 'purchase_purchase_items'

    # Must also autocomplete the unit field
    assert find_field('purchase_purchase_items_attributes_0_unit').value.present?
  end

  private

    def fill_in_new_purchase
      provider = providers(:arcor)

      page.execute_script "$('#purchase_provider').focus().val('#{provider.name}').keydown()"

      find('.ui-autocomplete li.ui-menu-item').click

      page.execute_script "$('#purchase_requested_at').focus()"

      find('.ui-datepicker .ui-state-highlight').click
    end

    def add_item item, index
      click_link I18n.t('purchases.new.item') if index > 1

      within "#purchase_items fieldset:nth-child(#{index})" do
        input_id = find('input[name$="[item]"]')[:id]
        page.execute_script "$('##{input_id}').focus().val('#{item.name}').keydown()"

        fill_in find('input[name$="[quantity]"]')[:id], with: '1'
        fill_in find('input[name$="[price]"]')[:id], with: (item.price * 0.8).to_s
        # Unit MUST be filled automatically
      end

      find('.ui-autocomplete li.ui-menu-item').click
    end

    def add_provider
      find("a[href='#{new_provider_path}']").click

      within '#modal' do
        fill_in_new_provider
      end

      assert find_field('purchase_provider').value.blank?

      assert_difference 'Provider.count' do
        find('#modal .btn.btn-primary').click
        assert page.has_no_css?('#modal')
      end

      assert find_field('purchase_provider').value.present?
    end

    def fill_in_new_provider
      attributes = generic_entity_attributes

      fill_in find('input[name$="[name]"]')[:id], with: attributes[:name]
      fill_in find('input[name$="[tax_id]"]')[:id], with: attributes[:tax_id]
      select I18n.t("entities.conditions.#{attributes[:tax_condition]}"),
        from: find('select[name$="[tax_condition]"]')[:id]
      fill_in find('input[name$="[address]"]')[:id], with: attributes[:address]

      add_city
    end
end
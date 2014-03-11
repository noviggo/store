selector = '#purchase_items [data-autocomplete-update-after]'

$(document).on 'update.autocomplete', selector, (event) ->
  item = event.item || $(this).data('item')

  $(this).closest('fieldset').find('input[name$="[unit]"]').val item.unit

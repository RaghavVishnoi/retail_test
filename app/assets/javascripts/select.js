$(document).on('ready page:load', function() {
  $('select').select2({
    allowClear: true,
    width: 'resolve'
  });

  $('#item-select, #user-select').each(function() {
    var $this = $(this);
    $this.select2({
      ajax: {
        url: $this.data('ajax-url'),
        dataType: 'json',
        delay: 250,
        data: function(term) {
          return {
            q: term
          }
        },
        results: function(data) {
          return {
            results: $.map(data, function(item) { return { id: item[1], text: item[0] }; })
          }
        },
        cache: true
      },
      minimumInputLength: 1,
      initSelection: function(element, callback) {
        var data = $(element).data('initvalue');
        callback(data);
      },
      allowClear: true,
      multiple: $this.data('multiple'),
      width: 300
    }).select2('val', []);
  });
});

function insert_selected_option(val, name, select) {
  var $option = $('<option selected="selected"></option>').text(name).attr('value', val)
  $(select).append($option).trigger('change');
}

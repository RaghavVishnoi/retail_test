$(document).on('ready page:load', function() {
  $('.form-field select').select2({
    allowClear: true,
    width: 'resolve'
  });

  $('#item-select, #user-select, .ajax-select').each(function() {
    var $this = $(this);
    $this.select2({
      createSearchChoice: function (term) {
        if($this.data('create_search_choice')) {
          return { id: term, text: term };  
        }
      },
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
          var key;
          if(key = $this.data('key')) {
            data = data[key];
          }
          return {
            results: $.map(data, function(item) {
              var id, text;
              text = item['display_name'] || item [0];
              id = item[1] || text; 
              return { id: id, text: text }; 
            })
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
function visualize_toggle_style(app_id, old_state, new_state) {
  if (old_state) {
    $$('.app-'+app_id).each(function(elt) {
      elt.removeClassName('visualize-toggle-'+old_state);
    });
  }
  $$('.app-'+app_id).each(function(elt) {
    elt.addClassName('visualize-toggle-'+new_state);
  });
}

function summary_reveal(identity, field, html) {
  if ($('summary-reveal')) {
    $('summary-reveal').remove();
  }
  var head = new Element('h2').insert(identity);
  var sub = new Element('h3').insert(field);
  var reveal = new Element('div', { 'id': 'summary-reveal' }).insert(head).insert(sub).insert(html)
  document.body.appendChild(reveal);
  Event.stop(event);
}

function table_sort(event) {
  var header = Event.findElement(event, 'th');
  var table = header.up('table');
  var column = header.up().childElements().indexOf(header);
  var rows = table.select('tr.app-row');
  
  var reverse = header.hasClassName('sorted');
  var top_row = rows[0].previous();
  
  function row_text(row) {
    return row.down('th,td', column).down(':only-child:last').innerHTML;
  }
  
  var numeric = true;
  rows = rows.sortBy(function(row) {
    var text = row_text(row);
    numeric = numeric && ! isNaN(parseFloat(text));
    return text;
  });
  
  if (numeric) {
    rows = rows.sortBy(function(row) {
      return -parseFloat(row_text(row));
    });
  }
  
  table.select('th').each(function (elt) {
    elt.removeClassName('sorted');
  });
  if ( ! reverse) {
    header.addClassName('sorted');
    rows.reverse(true);
  }
  rows.each(function(row) {
    top_row.insert({ after: row });
  });
}

function table_hide(event) {
  var header = Event.findElement(event, 'th');
  var table = header.up('table');
  var column = header.up().childElements().indexOf(header);
  var rows = table.select('tr.app-row');
  
  var hidden = header.hasClassName('hidden');
  
  rows.each(function(row) {
    row.down('th,td', column).setStyle({
      'max-width': hidden ? null : '0.5em',
      'color': hidden ? null : '#eee'
    });
  });
  
  header.toggleClassName('hidden');
}

document.observe("dom:loaded", function() {
  document.on('click', function() {
    if ($('summary-reveal')) {
      $('summary-reveal').remove();
    }
  });
});

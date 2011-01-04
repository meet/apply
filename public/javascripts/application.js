document.observe("dom:loaded", function() {
  $$('input.openclose');
  $$('input.openclose').each(function(elt) {
    elt.setStyle({ display: 'none' });
    var div = Element('div', { 'class': 'openclose-container' });
    div.insert(elt.insert({ after: div }).remove());
    div.insert('<div class="openclose-is-open">open</div>')
    div.insert('<div class="openclose-is-close">closed</div>')
  });
  $$('input.openclose:checked').each(function(elt) {
    elt.up().addClassName('openclose-open');
  });
  $$('.openclose-is-open').each(function(elt) {
    elt.on('click', function() {
      elt.previous('input.openclose:checked').writeAttribute('checked', false);
      elt.up().removeClassName('openclose-open');
    });
  });
  $$('.openclose-is-close').each(function(elt) {
    elt.on('click', function() {
      elt.previous('input.openclose').writeAttribute('checked', true);
      elt.up().addClassName('openclose-open');
    });
  });
});

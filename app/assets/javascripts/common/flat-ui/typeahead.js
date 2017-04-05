document.addEventListener('turbolinks:load', function() {

  // Typeahead
  if ($('#typeahead-demo-01').length) {
    var states = new Bloodhound({
      datumTokenizer: function (d) { return Bloodhound.tokenizers.whitespace(d.word); },
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      limit: 4,
      local: [
        { word: 'Alabama' },
        { word: 'Alaska' },
        { word: 'Arizona' },
        { word: 'Arkansas' },
        { word: 'California' },
        { word: 'Colorado' }
      ]
    });

    states.initialize();

    $('#typeahead-demo-01').typeahead(null, {
      name: 'states',
      displayKey: 'word',
      source: states.ttAdapter()
    });
  }
});

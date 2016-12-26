class @BlogEditorIntro extends MediumEditor

  # FACTORY
  @make: (tpl) ->
    $editable = $ '.editable-intro'

    if $editable.data('mediumEditor')
      return $editable.data('mediumEditor')

    # Set up the medium editor with image upload
    editor = new BlogEditorIntro $editable[0],
      buttonLabels: 'fontawesome'
      extensions:
        placeholder:
          text: ''
      toolbar:
        buttons: ['bold', 'italic', 'underline', 'anchor', 'pre', 'h1', 'h2', 'orderedlist', 'unorderedlist', 'quote', 'image']

    # Disable medium toolbar if we are in a code block
    editor.subscribe 'showToolbar', (e) =>
      if @inPreformatted()
        editor.toolbar.hideToolbar()


    $editable.data 'mediumEditor', editor
    editor

  # INSTANCE METHODS

  constructor: ->
    @init.apply @, arguments

  # Return medium editor's contents
  contents: ->
    @serialize()['element-0'].value

  # Return medium editor's contents thru HTML beautifier
  pretty: ->
    html_beautify @contents(),
      preserve_newlines: false
      indent_size: 2
      wrap_line_length: 0

  # Highlight code blocks
  highlightSyntax: ->
    hljs.configure userBR: true

    br2nl = (i, html) ->
      html
        # medium-editor leaves <br>'s in <pre> tags, which screws up
        # highlight.js. Replace them with actual newlines.
        .replace(/<br>/g, "\n")
        # Strip out highlight.js tags so we don't create them multiple times
        .replace(/<[^>]+>/g, '')

    # Remove 'hljs' class so we don't create it multiple times
    $(@elements[0]).find('pre').removeClass('hljs').html(br2nl).each (i, block) ->
      hljs.highlightBlock block

  @inPreformatted: ->
    node = document.getSelection().anchorNode
    current = if node and node.nodeType == 3 then node.parentNode else node

    loop
      if current.nodeType == 1
        if current.tagName.toLowerCase() is 'pre'
          return true

        # do not traverse upwards past the nearest containing editor
        if current.getAttribute('data-medium-element')
          return false
      current = current.parentNode
      unless current
        break
    false

Template.readMeter.onRendered ->
  m = document.getElementById('read-meter')
  f = document.getElementById('meter-filler')
  w = document.getElementById('meter-fill')
  p = document.getElementById('read-meter-minutes')
  w.style.width = 0 + 'px'
  d = m.offsetTop
  # wait until all images are loaded
  postHeight = $('#read-meter-styles').parent().height() - 250
  p.innerHTML = 'A ' + Math.ceil(postHeight / 1000) + ' minute read.'
  postWidth = $('#read-meter').parent().width()
  $(window).scroll ->
    if m
      #recalculate postHeight as images are not rendered in the beginning
      postHeight = $('#read-meter-styles').parent().height() - 250
      p.innerHTML = 'A ' + Math.ceil(postHeight / 1000) + ' minute read.'
      scroll = $(window).scrollTop()
      ratio = scroll / postHeight
      w.style.width = ratio * postWidth + 'px'
      if scroll >= d and ratio <= 1
        m.className = 'read-meter-fixed'
        f.style.height = '180px'
      else
        m.className = ''
        f.style.height = ''
    return
  $(window).resize ->
    #postWidth = $(window).width() * 0.8;
    postWidth = $('#read-meter').parent().width()
    return
  return

# Provide data to custom templates, if any
Meteor.startup ->
  if Blog.settings.readMeterTemplate
    customLatest = Blog.settings.readMeterTemplate
    Template[customLatest].onRendered Template.readMeter._callbacks.rendered[0]
    



Template.subscribeEmailSmall.events 'submit form#subscribe-form-small': (e, t) ->
  e.preventDefault()
  form = t.$('#subscribe-form-small')
  form.validate()
  l = t.$('button[type=submit]', form).ladda()
  if form.valid()
    l.ladda 'start'
    email = form.find('#Email').val()
    # insert email address into CampaignMonitor list
    Meteor.call 'createSend', email, ' ', (err) ->
      l.ladda 'stop'
      if err
        console.log 'list error', err
        toastr.error err.message
      else
        console.log 'list success'
        toastr.success 'We got you covered!'
      return
  return

#Template.readCounter.onCreated ->
  #readCountSub = Blog.subs.subscribe 'blog.readCountBySlug', @data.slug
  #console.log 'context-onCreated:', @
    
#Template.readCounter.onRendered ->
#  doc = Blog.ReadCount.first slug: @data.slug
#  #console.log 'context-onRendered:', @, doc

Template.readCounter.helpers
  readCounter: ->
    doc = Blog.ReadCount.first slug: @slug
    #console.log 'context-helper:', @
    doc.count
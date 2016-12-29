Template.blogLatest.onRendered () ->
  # fetch the last 25 posts max for random tiles
  num = if @data?.num then @data.num else 25
  @autorun ->
    Meteor.subscribe 'blog.posts', num


Template.blogLatest.helpers
    
  latest: ->
    num = if @num then @num else 3
    Blog.Post.all
      limit: num
      sort: updatedAt: -1
        
  random: ->
    # slug of the currently displayed post
    Blog.Post.random(@slug)

  date: (date) ->
    if date
      date = new Date(date)
      moment(date).format('MMMM Do, YYYY')
        
  gravatarUrl: -> Gravatar.imageUrl @md5hash, secure: true


# Provide data to custom templates, if any
Meteor.startup ->
  if Blog.settings.blogLatestTemplate
    customLatest = Blog.settings.blogLatestTemplate
    Template[customLatest].onRendered Template.blogLatest._callbacks.rendered[0]
    Template[customLatest].helpers
      latest: Template.blogLatest.__helpers.get('latest')
      random: Template.blogLatest.__helpers.get('random')
      date: Template.blogLatest.__helpers.get('date')
      gravatarUrl: Template.blogLatest.__helpers.get('gravatarUrl')

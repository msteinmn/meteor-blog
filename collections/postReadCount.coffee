class Blog.ReadCount extends Minimongoid

  @_collection: new Meteor.Collection 'post_read_count'


if Meteor.isServer
  Meteor.methods
    increment_count: (slug) ->
      check slug, String
        
      #console.log 'increment_count:', slug
      doc = Blog.ReadCount.first slug: slug
      if doc
        doc.update _id: doc._id, count: doc.count+1
        #console.log 'Counter incremented'
        if doc.errors
          console.log 'Error incrementing count:', doc.errors
      else
        readCount = Blog.ReadCount.create count: 100, slug: slug
        if readCount.errors
          console.log 'Error creating counter', readCount.errors
        else
          console.log 'Counter did not exist, created'
        

Blog.ReadCount._collection.allow
  insert: (userId, doc) ->
    Meteor.call 'isBlogAuthorized', doc
  update: (userId, doc, fields, modifier) ->
    true
  remove: (userId, doc) ->
    Meteor.call 'isBlogAuthorized', doc
class app.Collections.Notifications extends Backbone.Collection
  model: app.Models.Notification
  url: 'https://api.github.com/notifications'

  initialize: ->
    @on 'reset', -> @select(undefined)
    @starred = new app.Collections.Starred()
    @starred.fetch()

  select: (model) ->
    previous = @selected
    @selected = model
    previous.trigger 'unselected' if previous
    model.trigger 'selected' if model
    @trigger 'selected', model, previous

  next: ->
    index = @indexOf(@selected)
    @at index + 1 if index >= 0

  prev: ->
    index = @indexOf(@selected)
    @at index - 1

  read: (options = {}) ->
    options.data = '{}'
    @sync 'update', @, options unless app.isDevelopment()
    @each (notification) -> notification.set 'unread', false

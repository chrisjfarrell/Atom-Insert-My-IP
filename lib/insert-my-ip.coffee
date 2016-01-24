{CompositeDisposable} = require 'atom'
window.$ = window.jQuery = require('./jquery-2.1.4.min.js')
window.ip = ""


module.exports =
  activate: ->
    atom.commands.add 'atom-workspace', "insert-my-ip:insert-ip", => @insert_ip()

    $.ajax
      url: 'https://api.ipify.org'
      type: 'GET'
      success: (data, status, response) ->
        # data is the object that contains all info returned
        window.ip=data

#writing to the snippets file seems to require a reload of atom before they can be read
#        FS = require "fs"
#        FS.writeFile("./.atom/packages/insert-my-ip/snippets/insert-my-ip.cson", "
#'.text.html.php':\n
#\  'insert_my_ip':\n
#\    'prefix': 'insert_my_ip'\n
#\    'body': '"+data+"'")


        atom.notifications.addSuccess("Your IP address has been received.", detail: window.ip);
      error: ->
        # Hard error
        atom.notifications.addError('Error getting your IP address');
      dataType: "html"

  insert_ip: ->
    # This assumes the active pane item is an editor
    editor = atom.workspace.getActivePaneItem()
    editor.insertText(window.ip)

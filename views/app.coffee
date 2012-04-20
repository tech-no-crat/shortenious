$(document).ready( ->
  console.log "Starting"
  $("button#submit").click( (e) ->
    setResultsClass
    link = $("#link").val()
    id = $("#id").val()
    $.post('/', {link: link, id: id}, (data) ->
      if data.substr(0, 2) == "OK"
        submitSuccess(data.substr(4))
      else
        submitError(data)
    )
  )
)

submitSuccess = (link) ->
  console.log "Success! Link: #{link}"
  $("#result").html("#{link} copied to clipboard.")
  setResultsClass("success")

submitError = (error) ->
  console.log error
  $("#result").html(error)
  setResultsClass("failure")

setResultsClass = (cl) ->
  $("#result").removeClass("failure")
  $("#result").removeClass("success")
  $("#result").addClass(cl) if cl!=undefined and typeof(cl)=='string'


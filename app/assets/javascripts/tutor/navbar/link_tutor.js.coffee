$(document).on "click", ".link-tutor-logout", (e) ->
  sessionStorage.removeItem('userId')

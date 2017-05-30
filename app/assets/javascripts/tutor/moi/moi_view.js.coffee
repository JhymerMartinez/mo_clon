dispatcher = null
customizeNavbarLink = ->
  userId = sessionStorage.getItem('userId')
  if userId
    $navbarLinkClient = $('#navbar-link-client')
    $navbarLinkAnalysis = $('#navbar-link-analysis')
    clientHref = $navbarLinkClient.attr('href')
    analysisHref = $navbarLinkAnalysis.attr('href')
    regexUrl = /\/\w*\/\w*/
    clientHref = regexUrl.exec(clientHref)[0]
    analysisHref = regexUrl.exec(analysisHref)[0]
    $navbarLinkClient.attr('href', "#{clientHref}/#{userId}")
    $navbarLinkAnalysis.attr('href', "#{analysisHref}/#{userId}")

    $analisysUserLink = $('#analysis-user-link')
    if $analisysUserLink[0]
      analisysUserHref = $analisysUserLink.attr('href')
      analisysUserHref = regexUrl.exec(analisysUserHref)[0]
      $analisysUserLink.attr('href', "#{analisysUserHref}/#{userId}")
  return

loadUserLinks = ->
  if sessionStorage.getItem('userId')
    customizeNavbarLink()
  return

loadSelectableList = ->
  listClientsId = '#list-clients'
  analisysUserLink = '#analysis-user-link'

  $(listClientsId).selectable
    create: (event, ui) ->
      userId = sessionStorage.getItem('userId')
      if userId
        $(this).find("#user_#{userId}").addClass('selectedfilter').addClass('ui-selected')
        if $(analisysUserLink).hasClass('disabled')
          $(analisysUserLink).removeClass('disabled')
      else
        $(analisysUserLink).addClass('disabled')
      return

    selected: (event, ui) ->
      if $(analisysUserLink).hasClass('disabled')
        $(analisysUserLink).removeClass('disabled')

      $(ui.selected).addClass('visible')
      $(ui.selected).addClass('selectedfilter').addClass('ui-selected')
      regexUser = /user_(\d*)/
      userId = regexUser.exec(ui.selected.id)[1]
      sessionStorage.setItem('userId', userId)
      customizeNavbarLink()
      return

    unselected: (event, ui) ->
      $(analisysUserLink).addClass('disabled')
      $(ui.unselected).removeClass('selectedfilter')
      return

sendInvitation = ->
  if (dispatcher && dispatcher.trigger)
    dispatcher.trigger('send_invitation')
  return

connectionWS = ->
  dispatcher = new WebSocketRails(window.location.host + '/websocket')

  dispatcher.bind 'client_connected', (data) ->
    console.log('Connection has been established: ', data)
    return
  return

$(document).on "ready page:load", connectionWS
$(document).on "ready page:load", loadSelectableList
$(document).on "ready page:load", loadUserLinks
$(document).on "click", "#button-send-invitation", sendInvitation

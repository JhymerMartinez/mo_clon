applyDatatables = ->
  $('.datatable').each ->
    columnDefs = []
    if $(this).data("includesActions")
      # disable sorting on last column if the datatable
      # intends to display actions
      columnDefs.push { "targets": -1, "orderable": false }

    $(this).dataTable
      sPaginationType: "full_numbers"
      bProcessing: true
      bServerSide: true
      sAjaxSource: $(this).data('source')
      columnDefs: columnDefs
      oLanguage:
        sUrl: "/datatables/datatables.es.txt"

# Listen for document.ready and page:load (turbolinks)
$(document).on "ready page:load", applyDatatables

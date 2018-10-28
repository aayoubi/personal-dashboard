class Dashing.Ratp extends Dashing.Widget
  onData: (data) ->
    for result in data.results
      transportId = Object.keys(result)[0]
      currentResult = result[transportId]
      
      if not $("##{transportId}").length
        $(".widget-ratp table").append(@createRow(currentResult.type, currentResult.id, transportId))

      @updateStop(transportId, currentResult.stop)
      @updateDest(transportId, currentResult.d1)
      @updateStatus(transportId, currentResult.status)
      @updateTime(transportId, currentResult.t1, currentResult.t2)

  createRatpTableCell: (tdId, tdClass, spanId) ->
    cell = $ "<td>"
    cell.addClass tdClass
    cell.attr 'id', tdId
    span = $ "<span>"
    span.attr 'id', spanId
    cell.append span
    return cell

  createTimeCell: (transportId, index) ->
    cellIdPrefix = transportId + '-' + index 
    return @createRatpTableCell(cellIdPrefix + '-time', 'time', cellIdPrefix + '-time-span')

  renameId: (id) ->
    if id == 'PC1'
      return '97'
    else if id == 'PC3'
      return '99'
    return id

  createRow: (type, id, transportId) ->
    cellIcon = $ "<td>"
    cellIcon.addClass "transport"
    imgIcon = $ "<img>"
    imgIcon.attr 'src', 'https://www.ratp.fr/sites/default/files/network/' + type + '/ligne' + @renameId(id) + '.svg'
    imgIcon.addClass type
    imgIcon.addClass 'icon'
    cellIcon.append imgIcon

    row = $ "<tr>"
    row.attr 'id', transportId
    row.append cellIcon
    row.append @createRatpTableCell(transportId + '-stop', 'stop', transportId + '-stop-span')
    row.append @createRatpTableCell(transportId + '-dest', 'dest', transportId + '-dest-span')
    row.append @createRatpTableCell(transportId + '-status', 'status', transportId + '-status-span')
    row.append @createTimeCell(transportId, 1)
    row.append @createTimeCell(transportId, 2)
    return row

  updateDest: (id, newValue) ->
    tdId = "##{id}-dest"
    spanId = "##{id}-dest-span"
    oldValue = $(spanId).html()
    if oldValue != newValue
      $(spanId).fadeOut(->
        $(tdId).css('font-size', '')
        $(this).html(newValue).fadeIn(->
          while (outer = $(tdId)[0]?.offsetWidth) < (scroll = $(tdId)[0]?.scrollWidth) && $(tdId).css('font-size').replace('px','') > 15
            $(tdId).css('font-size','-=0.5')
          if outer < scroll
            $(tdId).addClass 'scroll'
          else
            $(tdId).removeClass 'scroll'
        )
      )

  updateTime: (id, firstArrivalTime, secondArrivalTime) ->
    firstArrivalTimeCellId = "##{id}-1-time"
    firstArrivalTimeSpanId = "##{id}-1-time-span"
    secondArrivalTimeCellId = "##{id}-2-time"
    secondArrivalTimeSpanId = "##{id}-2-time-span"
    if $(firstArrivalTimeSpanId).html() != firstArrivalTime
      @updateTimeCell(firstArrivalTimeCellId, firstArrivalTimeSpanId, firstArrivalTime)
    if $(secondArrivalTimeSpanId).html() != secondArrivalTime
      @updateTimeCell(secondArrivalTimeCellId, secondArrivalTimeSpanId, secondArrivalTime)

  updateTimeCell: (tdId, spanId, newValue) ->
    $(spanId).fadeOut(->
      $(tdId).css('font-size', '')
      $(this).html(newValue).fadeIn(->
        while $(tdId)[0]?.offsetWidth < $(tdId)[0]?.scrollWidth && $(tdId).css('font-size').replace('px','') > 10
          $(tdId).css('font-size','-=0.5')
      )
    )

  updateStop: (id, newValue) ->
    tdId = "##{id}-stop"
    spanId = "##{id}-stop-span"
    oldValue = $(spanId).html()
    if oldValue != newValue
      $(spanId).fadeOut(->
        $(tdId).css('font-size', '')
        $(this).html(newValue).fadeIn(->
          while (outer = $(tdId)[0]?.offsetWidth) < (scroll = $(tdId)[0]?.scrollWidth) && $(tdId).css('font-size').replace('px','') > 15
            $(tdId).css('font-size','-=0.5')
          if outer < scroll
            $(tdId).addClass 'scroll'
          else
            $(tdId).removeClass 'scroll'
        )
      )

  updateStatus: (id, newValue) ->
    tdId = "##{id}-status"
    spanId = "##{id}-status-span"
    oldValue = $(spanId).html()
    if oldValue != newValue
      $(spanId).fadeOut(->
        $(tdId).css('font-size', '')
        $(this).html(newValue).fadeIn(->
          while (outer = $(tdId)[0]?.offsetWidth) < (scroll = $(tdId)[0]?.scrollWidth) && $(tdId).css('font-size').replace('px','') > 15
            $(tdId).css('font-size','-=0.5')
          if outer < scroll
            $(tdId).addClass 'scroll'
          else
            $(tdId).removeClass 'scroll'
        )
      )
  

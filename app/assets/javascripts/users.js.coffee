jQuery ->
  $('#user_group_id').parent().hide()
  groups = $('#user_group_id').html()
  $('#user_school_id').change ->
    school = $('#user_school_id :selected').text()

    escaped_school = school.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(groups).filter("optgroup[label='#{escaped_school}']").html()
    if options
      $('#user_group_id').html(options)
      $('#user_group_id').parent().show()
    else
      $('#user_group_id').empty()
      $('#user_group_id').parent().hide()
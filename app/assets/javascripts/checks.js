$(function() {

  $(".check_category ul").each(function() {
    var submitting = false;
    var timer = null;
    $(this).sortable({
      connectWith: ".list-group",
    }).bind('sortupdate', function() {
      var list = $(this); 
      submitting = true;
      if (submitting) {
        clearTimeout(timer);
      }
      $('.status').text("Unsaved changes...");
      timer = setTimeout(function() {
        submitting = false;
        $('.status').text("Saving categorisations...");

        var typeid = list.parent('.check_category').attr('id').replace("checktype-", '');
        var ids = [];
        list.find('.check').each(function() {
          var check_id = $(this).attr('id').replace("check-", "");
          ids.push(check_id);
        });

        $.ajax({
          type: "POST",
          url: "/checktypes/"+typeid+"/reorder",
          data: {"checks[]": ids},
          success: function(data)
          {
            $('.status').text("Check categorisation saved.");
          }
        });
      }, 1000);
    });
  });
});

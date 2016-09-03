
// var milestone_fields;
// milestone_fields = function() {
//  console.log("load")
//   is_milestone = $('#issue_tracker_id').val() == 2
//   if (is_milestone){
//     $('#assigned_to_line').hide();
//   }
// };
//
// $(document).ready(milestone_fields);
// $(document).on('page:load', milestone_fields);

$(document).on('ready page:load', function () {
  console.log("load")
  is_milestone = $('#issue_tracker_id').val() == 2
    if (is_milestone){
      $('#assigned_to_line').hide();
    }
});

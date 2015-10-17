$(document).on('page:change', function(){
 
  $(window).bind('rails:flash', function(e, params) {

    new PNotify({
      title: params.type,
      text: params.message,
      type: params.type
    });
  });

  $(".menu_icons").click(function(){
    $(".submenu_toggle").toggleClass("dis_block") 
  });

  $('#add_more_worker_email').click(function(){
    $('.cong_input_wrap.mr_up ol').append('<li><input type="email" name="email_ids[]" placeholder="Daycare worker email"></li>');
  });

  $('#add_more_parent_email').click(function(){
    $('.cong_input_wrap.mr_up ol').append('<li><input type="email" name="email_ids[]" placeholder="Daycare parent email"></li>');
  });

  $('.datetimepicker').datetimepicker({
    formatDate: 'd-m-Y',
    minDate: getFormattedDate(new Date()),
    theme:'default'
  });

  function getFormattedDate(date) {
    var day = date.getDate();
    var month = date.getMonth() + 1;
    var year = date.getFullYear().toString().slice(2);
    return day + '-' + month + '-' + year;
  }

  $('#select_country').change(function(){
    $(this).closest('form').submit();
  });

});
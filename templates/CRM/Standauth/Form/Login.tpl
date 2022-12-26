{foreach from=$elementNames item=elementName}
  <div class="crm-section">
    <div class="label">{$form.$elementName.label}</div>
    <div class="content">{$form.$elementName.html}</div>
    <div class="clear"></div>
  </div>
{/foreach}

<div class="crm-submit-buttons">
  {include file="CRM/common/formButtons.tpl" location="bottom"}
</div>

{literal}
<script type="text/javascript">
(function($) {
  $('#Login').on('submit', function(event) {
    event.preventDefault();

    var request = new XMLHttpRequest();
    request.open("POST", CRM.url("civicrm/authx/login"));
    request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    request.responseType = "json";
    request.onreadystatechange = function() {
      console.log(request.response);
      if (request.readyState == 4) {
        if (request.status == 200) {
          if (request.response.user_id > 0) {
            window.location.href = "/civicrm?reset=1";
          } else {
            // probably won't ever be here?
            alert("Success but fail because ???");
            console.log(request.response);
          }
        } else {
          // todo - send errors back to the form via whatever forms framework we'll be using
          alert("Fail with status code " + request.status + " " + request.statusText);
          console.log(request.response);
        }
      }
    };
    var data = '_authx=Basic ' + btoa(encodeURIComponent($('#username').val()) + ':' + $('#password').val());
    request.send(data);
  });
})(CRM.$);
</script>
{/literal}

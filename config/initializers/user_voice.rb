USER_VOICE = <<-EOS
<script type="text/javascript">
var uservoiceOptions = {
  /* required */
  key: 'hyewye',
  host: 'hyewye.uservoice.com', 
  forum: '40436',
  showTab: true,  
  /* optional */
  alignment: 'right',
  background_color:'#719935', 
  text_color: 'white',
  hover_color: '#DF793C',
  lang: 'en'
};

function _loadUserVoice() {
  var s = document.createElement('script');
  s.setAttribute('type', 'text/javascript');
  s.setAttribute('src', ("https:" == document.location.protocol ? "https://" : "http://") + "cdn.uservoice.com/javascripts/widgets/tab.js");
  document.getElementsByTagName('head')[0].appendChild(s);
}
_loadSuper = window.onload;
window.onload = (typeof window.onload != 'function') ? _loadUserVoice : function() { _loadSuper(); _loadUserVoice(); };
</script>
EOS
<?php
	require_once('mtTouch_getSetting.php');

	function smarty_function_mtadsensechannel($args, &$ctx)
	{
		return mtTouch_getSetting($args, $ctx, 'mttouch_google_adsense_channel');
	}
?>
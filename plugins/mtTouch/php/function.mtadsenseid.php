<?php
	require_once('mtTouch_getSetting.php');

	function smarty_function_mtadsenseid($args, &$ctx)
	{
		return mtTouch_getSetting($args, $ctx, 'mttouch_google_adsense_id');
	}
?>
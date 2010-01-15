<?php
	function mtTouch_getSetting($args, &$ctx, $setting)
	{
		$blog = $ctx->stash('blog');
		$plugin_data = $ctx->mt->db->fetch_plugin_data('mtTouch', 'configuration:blog'.$blog['blog_id']);

		if (isset($plugin_data[$setting]))
			return $plugin_data[$setting];
		return '';
	}
?>
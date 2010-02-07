package MTTouch::Tags;
use strict;

sub _get_val
{
	my ($ctx, $args, $config_key) = @_;
	my $plugin = MT->component('mtTouch');
	
	my $blog = $ctx->stash('blog');
	
	if ($blog and $blog->id)
	{
		return $plugin->get_config_value($config_key, 'blog:' . $blog->id);
	}
	
	return '';
}

sub _hdlr_mtt_adsense_id
{
	return _get_val(@_, 'mttouch_google_adsense_id');
}

sub _hdlr_mtt_adsense_channel
{
	return _get_val(@_, 'mttouch_google_adsense_channel');
}

1;


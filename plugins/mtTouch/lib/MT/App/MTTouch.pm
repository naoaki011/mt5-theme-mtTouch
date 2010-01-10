package MT::App::MTTouch;

use strict;
use base qw(MT::App);

sub init
{
	my $app = shift;
	$app->SUPER::init(@_) or return;
	$app->add_methods(
		ajax_show_more_entries => \&ajax_show_more
	);
	return $app;
}

sub ajax_show_more
{
        my $app = shift;
        my $blog_id = $app->param('blog_id');
	my $lastEntryId = $app->param('last_entry');
        use JSON;
        unless ($blog_id) {
                return JSON::objToJson( { successful => 0, message => 'No blog ID specified' } );
        }
        unless ($lastEntryId) {
		return JSON::objToJson( { successful => 0, message => 'No last entry ID specified' } );
        }

        use MT::Blog;
        use MT::Entry;
        use MT::Template;
        use MT::Template::Context;

        my $template = MT::Template->load({ blog_id => $blog_id, name => 'Entry Display' });
        my $ctx = MT::Template::Context->new();

        $ctx->stash('blog', MT::Blog->load({id => $blog_id}) );

	my $lastEntry = MT::Entry->load({id => $lastEntryId});

	##This attempts to load up to 10 entries that were published right before the entry that was last displayed
	##on one of the pages which can call this Ajax functionality.

        my @entries = MT::Entry->load(
				{
					blog_id => $blog_id, 
					authored_on => { '<' => $lastEntry->authored_on }
				}, 
				{
					sort => 'authored_on', 
					direction => 'descend', 
					limit => 10
				});
	my $str = '';
	
	foreach my $entry (@entries)
	{
		$app->log({ message => $entry->created_on});
		$ctx->stash('entry', $entry);
		$str .= $template->build($ctx, {});
	}

        return JSON::objToJson({ updateHTML => $str, lastID => ($entries[$#entries] ? $entries[$#entries]->id : -1)} );
}


1;


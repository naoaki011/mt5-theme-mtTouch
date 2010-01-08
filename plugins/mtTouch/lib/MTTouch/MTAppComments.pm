package MTTouch::MTAppComments;
use strict;

##Copied and modified from MT::App::Community::do_login
##which is itself an updated version of MT::App::Comments

##Example result
##{
##	successful: true,
##	message: 'X, Y, Z'
##}
##{
##	successful: false,
##	message: 'Invalid login!'
##}

sub ajax_native_verification
{
	my $app = shift;
	use JSON;
	
	my $q       = $app->param;
	my $name    = $q->param('username');
	my $blog_id = $q->param('blog_id');
	my $blog    = MT::Blog->load($blog_id) if (defined $blog_id);
	my $auths   = $blog->commenter_authenticators if $blog;
	
	if ( $blog && $auths !~ /MovableType/ ) {
	    $app->log(
	        {   message => $app->translate(
	                'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.',
	                $name, $blog->name, $blog_id
	            ),
	            level    => MT::Log::WARNING(),
	            category => 'login_commenter',
	        }
	    );
	    return JSON::objToJson( { successful => 0, message => 'Invalid login.'} );
	}
	
	require MT::Auth;
	my $ctx = MT::Auth->fetch_credentials( { app => $app } );
	$ctx->{blog_id} = $blog_id;
	my $result = MT::Auth->validate_credentials($ctx);
	my ( $message, $error );
	if (   ( MT::Auth::NEW_LOGIN() == $result )
	    || ( MT::Auth::NEW_USER() == $result )
	    || ( MT::Auth::SUCCESS() == $result ) )
	{
	    my $commenter = $app->user;
	    if ( $q->param('external_auth') && !$commenter ) {
	        $app->param( 'name', $name );
	        if ( MT::Auth::NEW_USER() == $result ) {
	            $commenter = $app->_create_commenter_assign_role(
	                $q->param('blog_id') );
	            return JSON::objToJson( { successful => 0, message => 'Invalid login'} )
	                unless $commenter;
	        }
	        elsif ( MT::Auth::NEW_LOGIN() == $result ) {
	            my $registration = $app->config->CommenterRegistration;
	            unless (
	                   $registration
	                && $registration->{Allow}
	                && (   $app->config->ExternalUserManagement
	                    || ( $blog && $blog->allow_commenter_regist ) )
	                )
	            {
	                return JSON::objToJson( { successful => 0, message => $app->translate(
	                        'Successfully authenticated but signing up is not allowed.  Please contact system administrator.'
	                    )
	                }) unless $commenter;
	            }
	            else {
	                return JSON::objToJson( { successful => 0, message => $app->translate('You need to sign up first.') })
	                unless $commenter;
	            }
	        }
	    }
	    MT::Auth->new_login( $app, $commenter );
	    if ( $app->_check_commenter_author( $commenter, $blog_id ) ) {
		$app->make_commenter_session($commenter);
	        return JSON::objToJson( 
			{ 
			successful => 1, 
			message => 'Thank you for logging in.',
			name => $commenter->nickname,
			url => $commenter->url
			});
	    }
	    $error   = $app->translate("Permission denied.");
	    $message = $app->translate(
	        "Login failed: permission denied for user '[_1]'", $name );
	}
	elsif ( MT::Auth::PENDING() == $result ) {
	
	    # Login invalid; auth layer reports user was pending
	    # Check if registration is allowed and if so send special message
	    if ( my $registration = $app->config->CommenterRegistration ) {
	        if ( $registration->{Allow} ) {
	            $error = $app->login_pending();
	        }
	    }
	    $error
	        ||= $app->translate(
	        'This account has been disabled. Please see your system administrator for access.'
	        );
	    $app->user(undef);
	    $app->log(
	        {   message => $app->translate(
	                "Failed login attempt by pending user '[_1]'", $name
	            ),
	            level    => MT::Log::WARNING(),
	            category => 'login_user',
	        }
	    );
	}
	elsif ( MT::Auth::INVALID_PASSWORD() == $result ) {
	    $message = $app->translate(
	        "Login failed: password was wrong for user '[_1]'", $name );
	}
	elsif ( MT::Auth::INACTIVE() == $result ) {
	    $message
	        = $app->translate( "Failed login attempt by disabled user '[_1]'",
	        $name );
	}
	else {
	    $message
	        = $app->translate( "Failed login attempt by unknown user '[_1]'",
	        $name );
	}
	$app->log(
	    {   message  => $message,
	        level    => MT::Log::WARNING(),
	        category => 'login_commenter',
	    }
	) if $message;
	$ctx->{app} ||= $app;
	MT::Auth->invalidate_credentials($ctx);
	
	return JSON::objToJson( { successful => 0, message => "$error\t$message"} );
}

1;


package Git::Libgit2::Repository;

use 5.10.0;

use strict;
use warnings;

use Path::Tiny qw//;
use FFI::Platypus::Declare;
use FFI::CheckLib;

use Moose;

has _object => (
    is => 'ro',
);

has is_bare => (
    is => 'ro',
    isa => 'Bool',
    lazy => 1,
    default => sub {
       _libgit2_repository_is_bare( $_[0]->_object ); 
    },
);

has path => (
    is => 'ro',
    lazy => 1,
    default => sub {
        _libgit2_repository_path( $_[0]->_object );
    }

);

sub init {
    my( $class, $dir, $is_bare ) = @_;
    $dir = Path::Tiny::path($dir);
    $dir->mkpath;
    $is_bare //= 0;

    my $repo = \my $value;
    $value = \my $inner;

    _libgit2_repository_init( $repo, $dir->stringify, $is_bare );

    return __PACKAGE__->new( _object => $$repo );
}

### the interface to libgit2

lib find_lib( lib => 'git2' ); 

attach 'git_libgit2_init' => [], 'int';

attach [ git_repository_init => '_libgit2_repository_init' ] 
        => [ 'opaque *', qw/ string int / ] => 'int';

attach [ 'git_repository_is_bare' => '_libgit2_repository_is_bare' ] 
    => [ qw/ opaque / ] => 'int';

attach [ git_repository_path => '_libgit2_repository_path' ] 
    => [ qw/ opaque / ] => 'string';

git_libgit2_init();

1;

__END__

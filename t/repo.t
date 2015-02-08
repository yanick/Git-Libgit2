use strict;
use warnings;

use Test::More tests => 1;

use Git::Libgit2::Repository;
use Path::Tiny qw/ tempdir /;

my $repo_dir = tempdir( DIR => 't/repos', CLEANUP => 0 );

diag "using dir $repo_dir";

my $repo = Git::Libgit2::Repository->init($repo_dir, 1);

is $repo->is_bare => 1, 'bare repo';

#  $repo->path adds the final '/'
like $repo->path, qr/^@{[$repo_dir->absolute]}\/?$/, 'repo path';





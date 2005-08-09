use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Time::Duration::Object',
    AUTHOR              => 'Ricardo Signes <rjbs@cpan.org>',
    VERSION_FROM        => 'lib/Time/Duration/Object.pm',
    ABSTRACT_FROM       => 'lib/Time/Duration/Object.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'     => 0,
        'Time::Duration' => 1.02,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Time-Duration-Object-* cover_db' },
);

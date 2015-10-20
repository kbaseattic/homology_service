use strict;
use Getopt::Long; 
use JSON;
use Pod::Usage;

use Template;

my $help = 0;
my ($in, $out);

GetOptions(
	'h'	=> \$help,
        'i=s'   => \$in,
        'o=s'   => \$out,
	'help'	=> \$help,
	'input=s'  => \$in,
	'output=s' => \$out,

) or pod2usage(0);


pod2usage(-exitstatus => 0,
          -output => \*STDOUT,
          -verbose => 2,
          -noperldoc => 1,
         ) if $help;


# do a little validation on the parameters


my ($ih, $oh);

if ($in) {
    open $ih, "<", $in or die "Cannot open input file $in: $!";
}
elsif (! (-t STDIN))  {
    $ih = \*STDIN;
}
if ($out) {
    open $oh, ">", $out or die "Cannot open output file $out: $!";
}
else {
    $oh = \*STDOUT;
}



# main logic

our $cfg = {};
#if (defined $ENV{KB_DEPLOYMENT_CONFIG} && -e $ENV{KB_DEPLOYMENT_CONFIG}) {
#    $cfg = new Config::Simple($ENV{KB_DEPLOYMENT_CONFIG}) or
#	die "can not create Config object";
#    print "using $ENV{KB_DEPLOYMENT_CONFIG} for configs\n";
#}
#else {
#    $cfg = new Config::Simple(syntax=>'ini');
#    $cfg->param('homology_service.megahit_cmd','megahit.tt');
#}



if ($ih) { 
  while(<$ih>) {
    my($metagenome_id, $filename) = split /\s+/;
    die "$filename not readable" unless (-e $filename and -r $filename);
    my $vars = {se_reads => "my.reads",
		base     => "base", 
	       };
    my $tt = Template->new();
    my $cmd = '';
    $tt->process("megahit.tt", $vars, \$cmd)  or die $tt->error(), "\n";
    print STDERR "cmd: $cmd", "\n";
    
  }
}
else {
  die "no input found, input is required";
}




 

=pod

=head1	NAME

assemble_metagenome.pl

=head1	SYNOPSIS

assemble_metagenome.pl <options>

=head1	DESCRIPTION

The assemble_metagenome.pl command ...

=head1	LIMITATION

At the current time, only one fastq or fasta file is taken as input. Multiple fastq files need to be concatenated together prior to running this script.

=head1	OPTIONS

=over

=item	-h, --help

Basic usage documentation

=item   -i, --input

The input file, default is STDIN. This is required. It contains the list of metagenomes to assemble.

=item   -o, --output

The output file, default is STDOUT. This is the metagenome id and the assembly file in tab delimited format.

=back

=head1	AUTHORS

Thomas Brettin

=cut



1;

#!/usr/bin/perl

use strict;
use Math::FFT;

# variables
my (
    $filename, # input file
    @samples,  # input data
    @fft,      # fft working space
    $fft_size  # size of fft <= 2^24
);

my $samplerate=48000;
my $minspectrum=0; # output all spectrum

if ( $#ARGV < 0 ) {
    print "Usage: $0 raw_audio_file\n";
    print "   raw_audio_file - 48000/16bit/mono\n";
    exit 0
}

$filename = $ARGV[0];

unless ( -r $filename ) {
    print "Can't read $filename\n";
    exit 1;
}

# read min value for output spectrum
if ( defined $ARGV[1] ) {
    $minspectrum = 0 + $ARGV[1];
}

# read samples from file
open (IN, $filename) || die "Can't open $filename!\n";
{ 
    my $in; 
    while (read(IN,$in,2)) {
        my $sample = unpack("s",$in);
        push @samples,$sample;
    }
}
close IN;

# calculate fft size for given file 
for (my $i = 2; $i <= 24; $i++ ) {
    my $num = 2 ** $i;
    if ( $#samples >= $num ) {
        $fft_size = $num;
    }
}

# make data for fft
for (my $i = 0; $i < $fft_size; $i++) {
    $fft[$i] = $samples[$i];
}

my $data = \@fft;
my $fft = Math::FFT->new($data);
my $spectrum = $fft->spctrm;

for ( my $i = 0; $i < $#{$spectrum}; $i++ ) {
    my $sp = @{$spectrum}[$i];
    my $freq = $i * $samplerate / $fft_size;
    if ($sp >= $minspectrum ) {
        printf "%d %6.3f %5.5f\n", $i, $freq, $sp;
    }
}

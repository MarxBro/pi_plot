#!/usr/bin/perl
######################################################################
# Pi plot -> me pintó plotear los decimales de pi...
######################################################################

use strict;
use autodie;
use bignum;
use Data::Dumper;
use Imager;
use Imager::Fill;
use File::Slurp "write_file";

my $pi;
my $img_x_size = 800;
my $img_y_size = 400;
my $img = Imager->new(
    xsize => $img_x_size,
    ysize => $img_y_size,
    channels => 3
    );
my $img_colorida = Imager->new(
    xsize => $img_x_size,
    ysize => $img_y_size,
    channels => 3
    );
my $img_3= Imager->new(
    xsize => $img_x_size,
    ysize => $img_y_size,
    channels => 3
    );
my $img_4= Imager->new(
    xsize => $img_x_size,
    ysize => $img_y_size,
    channels => 3
    );
my $img_M= Imager->new(
    xsize => $img_x_size,
    ysize => $img_y_size,
    channels => 3
    );
my $ttlfont = Imager::Font->new(
    file => './Inconsolata-Regular.ttf',
    type => 'ft2'
);

my $digitos_pi_max = 500;
# menos colorido, solo tonos de rojo...
my %chars_to_plot = (
   0=>'#ffffff',
   1=>'#ffcccc',
   2=>'#ff9999',
   3=>'#ff4d4d',
   4=>'#ff0000',
   5=>'#cc0000',
   6=>'#990000',
   7=>'#660000',
   8=>'#330000',
   9=>'#000000',
);
# mas colorido
my %colorrr_to_plot = (
   0=>'#ff0000',
   1=>'#ff4000',
   2=>'#ff8000',
   3=>'#ffbf00',
   4=>'#ffff00',
   5=>'#bfff00',
   6=>'#80ff00',
   7=>'#40ff00',
   8=>'#00ff00',
   9=>'#00ff40',
);
#Mi paletta...
my %MIO_to_plot = (
   0=>'#faf0f0',
   1=>'#dbb294',
   2=>'#d09471',
   3=>'#c14a44',
   4=>'#633621',
   5=>'#3e4d19',
   6=>'#1f5c50',
   7=>'#123629',
   8=>'#0a1d1f',
   9=>'#2e0f24',
);
my $pi = bignum::bpi($digitos_pi_max);
$pi =~ s/\.//;
#say $pi and die;
my @pi_digits = split(undef,$pi);
my @ploty = map { $chars_to_plot{$_} } @pi_digits;
my @ploty_2 = map { $colorrr_to_plot{$_} } @pi_digits;
my @ploty_M = map { $MIO_to_plot{$_} } @pi_digits;
#print Dumper(@ploty) and die;

my $in = 0;
my $offset = 2;
my $ystep = $img_y_size / 10; # - $offset;
my $xstep = $img_x_size / 50; # - $offset;
my %seen_before = (
    0=>0,
    1=>0,
    2=>0,
    3=>0,
    4=>0,
    5=>0,
    6=>0,
    7=>0,
    8=>0,
    9=>0,
);
my $out_txt = 'pi_decimales.txt';
my $out_write ;
foreach my $y (0 .. 9){
    foreach my $x (0 .. 49){
        $img->box(
            color=> $ploty[$in],
            xmin => $x * $xstep,
            xmay => $x * $xstep + $xstep,
            ymin => $y * $ystep,
            ymax => $y * $ystep + $ystep,
            filled => 1
            );
        $img_colorida->box(
            color=> $ploty_2[$in],
            xmin => $x * $xstep,
            xmay => $x * $xstep + $xstep,
            ymin => $y * $ystep,
            ymax => $y * $ystep + $ystep,
            filled => 1
            );
        $img_3->box(
            color=> $ploty_2[$in],
            xmin => $x * $xstep,
            xmay => $x * $xstep + $xstep,
            ymin => $y * $ystep,
            ymax => $y * $ystep + $ystep,
            filled => 1
            );
        $img_4->box(
            color=> $ploty_2[$in],
            xmin => $x * $xstep,
            xmay => $x * $xstep + $xstep,
            ymin => $y * $ystep,
            ymax => $y * $ystep + $ystep,
            filled => 1
            );
        $img_M->box(
            color=> $ploty_M[$in],
            xmin => $x * $xstep,
            xmay => $x * $xstep + $xstep,
            ymin => $y * $ystep,
            ymax => $y * $ystep + $ystep,
            filled => 1
            );
        #Escribi el numero papu
        my $digit_p = $pi_digits[$in];
        $out_write .= " " . $digit_p . " ";
        my $tamagno = 11;
        $img_3->string(
            font => $ttlfont,
            text => $digit_p,
            x => $x * $xstep + $tamagno ,
            y => $y * $ystep + $tamagno,
            size => $tamagno,
            color => '#000000',
        );
        #Escribi el numero a no ser que ya este impreso.
        unless ($seen_before{$digit_p}){
            $img_4->string(
                font => $ttlfont,
                text => $digit_p,
                x => $x * $xstep + $tamagno,
                y => $y * $ystep + $tamagno,
                size => $tamagno,
                color => '#000000',
                );
        }
        
        $seen_before{$digit_p}++;
        $in++;
    }
    $out_write .=  "\n";
}
$img->write         ( file => 'pi.png',             type => 'png' );
$img_colorida->write( file => 'pi_color.png',       type => 'png' );
$img_3->write       ( file => 'pi_nros.png',        type => 'png' );
$img_4->write       ( file => 'pi_nros_unicos.png', type => 'png' );
$img_M->write       ( file => 'pi_M.png',           type => 'png' );
write_file($out_txt, $out_write);

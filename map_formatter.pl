#!/usr/bin/perl

use warnings;
use strict;

#Usage ./map_formatter.pl maptoformat.txt name_of_map_to_output.map
# your map

my $input_map=shift;
my $name=shift;

my $loc_counter=0;
my @map_data= read_table(\$input_map); 	
my @ordered_map=();
my $count=0;
my %map=parse_map(\@map_data,\@ordered_map,\$count);

open(OUT1,">$name.map");
print OUT1 "; ngrp=".scalar(@ordered_map).", nloc= ".$count.";\r\n";

foreach( @ordered_map){
		print OUT1 "group ".$_."\r\n";
		#print "group ".$_."\r\n";
		my @lg=@{$map{$_}};
			foreach (@lg){
				#print $_."\n";
				my @split=split(',',$_);
				print OUT1 $split[1]."\t",$split[2]."\t ;\r\n";
				}
		};
close OUT1;



sub read_table{
    my ($file)=@_;
    
    print "Reading in $$file \n ";
    open(IN,$$file);
    my @array= <IN>;
    close IN;
    return @array;
}
sub parse_map{
	my($map,$order,$count)=@_;
	my %HoA=();
	my $key=();
	my @array=();
	my $flag=0;
	print "ARRAY LENGTH ".scalar(@$map)." \n";
	
	for(my $i=0;$i<scalar(@$map);$i++){
		@$map[$i]=~s/\r\n//g;
		my @split=split(',',@$map[$i]);
		#print $split[0]."\n";
		
		if ($i==0){
		print "FIRST LINE\n";
			$flag=$split[0];
			push (@$order,$flag);
			#push (@array,@$map[$i]);
			$$count=$$count+1;
		}
		if ($i==(scalar(@$map)-1)){
			print "LAST LINE\n";
			$flag=$split[0];
			push (@array,@$map[$i]);
			$$count=$$count+1;
			my @tmp=@array;
			$HoA{$flag}=\@tmp;
		}
		elsif($split[0] eq $flag){
			#print "NORMAL \n";
			$$count=$$count+1;
			push (@array,@$map[$i]);
		}
		elsif($split[0] ne $flag){
			print "CHANGING LG from $flag to $split[0] \n";
			
			my @tmp=@array;
			$HoA{$flag}=\@tmp;
			@array=();
			$flag=$split[0];
			$$count=$$count+1;
			push (@$order,$flag);
			push (@array,@$map[$i]);
		}
	}
		return %HoA;
	
}


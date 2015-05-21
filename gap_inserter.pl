#!/usr/bin/perl

use warnings;
use strict;

my $input_file=shift;
my $number_file=shift;
my $output=shift;

my @loc_data= read_table(\$input_file); 	
my @number_data= read_table(\$number_file); 	

#print @loc_data;
#exit;

print "parsing loc file\n";
my %parsed_loc=parse_loc(\@loc_data);	

#CHECK LOC FILE PARSED OK
#foreach (keys %parsed_loc){
#print $_;
#print $parsed_loc{$_};
#exit;
#}
#exit;

print "Marker Output \n";
output_marker(\%parsed_loc, \@number_data, $output);
	
#   
sub output_marker{

my ($combined, $number_data,$name,)=@_;
my %combined_marker=%{$combined};
my @number_data=@{$number_data};
my $loc_name=$name; 
my $num=scalar (keys %combined_marker);

  open(OUT,">$loc_name");
  print OUT "name = EMxFE\r\n";
  print OUT "popt = CP\r\n";
  print OUT "nind = 188\r\n";
  print OUT "nloc = ".$num."\r\n";
  print OUT "\r\n";
  
      
       foreach my $val (keys %combined_marker){	
			#chomp $val;
			print OUT $val;
		#	print $val."\n";
			
			my @split_marker=split(' ' ,$combined_marker{$val});
			for (my $i=0; $i<scalar(@number_data);$i++){
				
				my $pos=0;
				if ($i>0){ 
					$pos=$number_data[$i]-$number_data[$i-1];
				}
				else{
					chomp $number_data[$i];
					$pos=$number_data[$i];
					}
				#print $pos."\n";
						
				if ($pos>1){
				#print $i."\t";
				#print $number_data[$i-1];
					for (my $j=0;$j<$pos-1;$j++){
					#	print "-- ";
						print OUT "-- ";
						
					}
					print OUT $split_marker[$i]." "
				}
				else{
				#	print $split_marker[$i-1]." ";
					print OUT $split_marker[$i]." ";
				}
				
			}
           print OUT "\r\n";
  #exit;
        
		}
}

sub parse_loc{
my($multiplex_data)=@_;
my $start=0;
my %loc_hash;
my $name=();
my $loc=();
for (my $i=$start;$i<scalar(@$multiplex_data);$i++){
			
		if (@$multiplex_data[$i] =~/AX/ && $i==$start){
				#chomp @$multiplex_data[$i];
				$name=@$multiplex_data[$i];
				#print $name;
				
		}
		elsif (@$multiplex_data[$i] =~/AX/ && $i>$start){
				$loc_hash{$name}=$loc;
				$loc=();
				#chomp @$multiplex_data[$i];
				$name=@$multiplex_data[$i];
				}
				 
			 
		else{
			#chomp @$multiplex_data[$i];
			$loc=$loc.@$multiplex_data[$i];
			}

}

#print keys %loc_hash;
return %loc_hash;

}

sub read_table{
    my ($file)=@_;
    
    print "Reading in $$file \n ";
    open(IN,$$file);
    my @array= <IN>;
    close IN;
    return @array;
}

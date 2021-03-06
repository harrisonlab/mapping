#!/usr/bin/perl

use warnings;
use strict;

my $input_file=shift;
my $output_name=shift;
my @loc_data= read_table(\$input_file); 	

print "parsing loc file\n";
my %parsed_loc=parse_loc(\@loc_data);	

#CHECK LOC FILE PARSED OK
#foreach (keys %parsed_loc){
#print $_."\n";
#print $parsed_loc{$_}."\n";
#exit;
#}
#exit;

print "Marker Output \n";
output_marker(\%parsed_loc, $output_name);
 
sub output_marker{

my ($combined,$name,)=@_;
my %combined_marker=%{$combined};
my $loc_name=$name; 
my $num=scalar (keys %combined_marker);

  open(OUT,">$loc_name");
    #print OUT "name = EMxFE\r\n";
    #print OUT "popt = CP\r\n";
    #print OUT "nind = 188\r\n";
    #print OUT "nloc = ".$num."\r\n";
    #print OUT "\r\n";
  
    #print @number_data;   
       
       
       foreach my $val (keys %combined_marker){	
			#chomp $val;
			print OUT $val."\r\n";
		#	print $val."\n";
			
		#	my @split_marker=split(' ' ,$combined_marker{$val});
		#	for (my $i=0; $i<188;$i++){         
			print OUT $combined_marker{$val}."\r\n";
				
		#	}
         #  print OUT "\r\n";
         
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
				#print "HERE\n";
				chomp @$multiplex_data[$i];
				@$multiplex_data[$i]=~s/\r\n//g;
				@$multiplex_data[$i]=~s/\r//g;
				$name=@$multiplex_data[$i];	
				
		}
		elsif (@$multiplex_data[$i] =~/AX/ && $i>$start){
				#print "HERE\n";
				$loc_hash{$name}=$loc;
				$loc=();
				chomp @$multiplex_data[$i];
				$name=@$multiplex_data[$i];
				}	 
		else{
			#print "HERE\n";
			chomp @$multiplex_data[$i];
			@$multiplex_data[$i]=~s/\r\n//g;
			@$multiplex_data[$i]=~s/\r//g;
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

#!/usr/bin/perl

#Soubroutine required by some programs to determine if a connection is blocked or not
#Author - Peter Wolf
#Date - 12-11-2024
#dougalite@gmail.com


sub isblocked
{
my $ip=shift(@_);
($ip,$port)=split(":",$ip);
@ipparts=split(".".$ip);
foreach (@_){
    ($bip,$bits)=split("/",$_);
    @bipparts=split(".".$bip);
    $blocked=1;
    for(my $i = 0; $i <= 3-$bits/8; $i++){
        if($ipparts[i]!=$bipparts[i]){
            $blocked=0;
        }

    }
    if($blocked==1){
        return(1);
    }
    }
    return(0);
}
1;

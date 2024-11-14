#!/usr/bin/perl

#NO GUARANTEE THIS PROGRAM DOES ANYTHING USEFUL. USE AT OWN RISK.

#A firewall program based on ufw but that may change if ufw gets sabotaged.

#It is important to understand that this software is not professionally written.The aim is to produce something that roughly works and is useful because
#I have not found any free linux security software useful apart from ufw.This program works well for me but may not work for anyone else.

#License - free.

#Author - Peter Wolf
#Date - 14-11-2024
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
    if($blocked=1){
        return(1);
    }
    }
    return(0);
}
print "Checking for ufw\n";
my @blockedips=split("\n",`sudo ufw status verbose`);
if(@blockedips<1){
	print"ERROR! ufw is not installed\n.Install ufw with the following command  : \"sudo apt install ufw -y\"   and run the program again.\n";
	exit(1);
}
else{
	print"ufw is installed\n";
	`sudo ufw enable`;
}
open (fh, ">", "efw.log"); 
print "Experimental firewall is running! logfile = efw.log in the same directory as the program.\n";
while(1){
$info=`ss -rt`;

my @blockedTO=();
my @blockedFROM=();

foreach (@blockedips){
	($TO,$FROM)=split("DENY IN",$_);
	$TO =~ s/^\s*(.*?)\s*$/$1/;
	$FROM =~ s/^\s*(.*?)\s*$/$1/;
	if($TO=~/\d+\.\d+\.\d+\.\d+/){
		push(@blockedTO,$TO);
	}
	if($FROM=~/\d+\.\d+\.\d+\.\d+/){
		push(@blockedFROM,$FROM);
	}
}

@badconnections=();

@connections=split(" ",$info);
foreach (@connections){
	$con=$_;
#	print "$con\n";
	if ($con=~/(\d+\.\d+\.\d+\.\d+\:)/){
		push(@badconnections,$con);
		}
	}
@badTO=();
@badFROM=();
$unblocked=0;
if (@badconnections>0){
    foreach (@badconnections){
        $bad=$_;
        #print $bad;
	($badip,$port)=split(":",$bad);
        if(isblocked($bad,@blockedTO)){
        }
        else{
		$unblocked+=1;
		push(@badTO,$badip);
        }
        if(isblocked($bad,@blockedFROM)){
        }
        else{
 		push(@badFROM,$badip);
		$unblocked+=1;
        }
    }
	if($unblocked>0){
		foreach(@badTO){
			`sudo ufw deny to $_`;
            print"Blocked to $_";
		print fh $_;
		}

		foreach(@badFROM){
			`sudo ufw deny from $_`;
            print"Blocked from $_";
		print fh $_;
		}

	}

}
sleep(2);
}




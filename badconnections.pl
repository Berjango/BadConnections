#!/usr/bin/perl


#NO GUARANTEE THIS PROGRAM DOES ANYTHING USEFUL. USE AT OWN RISK.

#Program to show suspected hacker connections.This is not 100% accurate but is useful.This program will produce both false positives and false negatives but they will
#hopefully be in the minority.I have used this technique to succesfully remove hackers from my computer but there is no guarantee that it will work for anyone else.

#This program uses and requires the ufw firewall which can be installed with "sudo apt install ufw". The program will try and install it automatically

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
    if($blocked=1){
        return(1);
    }
    }
    return(0);
}
print "Checking for ufw\n";
my @blockedips=split("\n",`sudo ufw status verbose`);
if(@blockedips<1){
	print"ERROR! ufw is not installed\n.You can exit the program (y=default) and install ufw with the following command  : \"sudo apt install ufw -y\"    or continue with limited functionality (n).\n";
	$choice = <STDIN>;
	chomp $choice;
	if($choice=~/y/){
	exit(1);
	}
	print("Continuing.\n");
}
else{
	print"ufw is installed\n";
	`sudo ufw enable`;
}
print "Finding bad connections.Please wait ,this can take a few minutes in some cases.\n";
$info=`ss -rt`;
#open my $handle, '<', "ipstoblock";
#chomp(my @blockedips = <$handle>);
#close $handle;

#print $connections;
#print @blockedips;

my @blockedTO=();
my @blockedFROM=();

foreach (@blockedips){
	#print "$_\n";
	($TO,$FROM)=split("DENY IN",$_);
	$TO =~ s/^\s*(.*?)\s*$/$1/;
	$FROM =~ s/^\s*(.*?)\s*$/$1/;
	#print("$TO $FROM\n");
	if($TO=~/\d+\.\d+\.\d+\.\d+/){
		#print ("TO=$TO\n");
		push(@blockedTO,$TO);
	}
	if($FROM=~/\d+\.\d+\.\d+\.\d+/){
		#print ("FROM=$FROM\n");
		push(@blockedFROM,$FROM);
	}
}
#print @blockedTO;
#print @blockedFROM;

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
        print $bad;
	($badip,$port)=split(":",$bad);
        if(isblocked($bad,@blockedTO)){
            print("    Blocked to");
        }
        else{
		$unblocked+=1;
		push(@badTO,$badip);
            print("     DANGER!!!!!!!!! NOT blocked to");
        }
        if(isblocked($bad,@blockedFROM)){
            print("    Blocked from\n");
        }
        else{
 		push(@badFROM,$badip);
		$unblocked+=1;
            print("     DANGER!!!!!!!!!!! NOT blocked from\n");
        }
    }
	if($unblocked>0){
	print("Do you want to block all the bad connections? (y/n)\n");
	$choice = <STDIN>;
	chomp $choice;
	if($choice=~/y/){
		foreach(@badTO){
			`sudo ufw deny to $_`;
		}

		foreach(@badFROM){
			`sudo ufw deny from $_`;
		}

	}
	}

}
else{
    print "No bad connectiosn detected.\n";
}





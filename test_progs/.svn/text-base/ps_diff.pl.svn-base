#! /usr/bin/perl -w

use POSIX;

$ps_diff_result = "";
$command = `ps aux`;
#$command = `cat ps_output`;
@output = split(/\n/, $command);
$nLine = 0;
foreach $line(@output){
	$nLine++;
	if($nLine == 1){
		next;	## skip the first line!!
	}
	chomp($line);
	@value = split(/ +/, $line);
	$len = length(@value);
	$USER = "";
	$PROC_ID = "";
	$TIME = "";
	$EXEC = "";
	$index = 0;
	foreach $token(@value){
	    if(length($token) > 0){
		if($index == 0){
			$USER = $token;
		}elsif($index == 1){
			$PROC_ID = $token;
    		}elsif($index == 9){
			$TIME = $token;
		}else{
			if($index >= 10){
				$EXEC = $EXEC.$token;
				if($index < $len){
					$EXEC = $EXEC." ";	
				}
			}
		}
	    }
	    $index++;
	}
	$process = $USER.";".$PROC_ID.";".$TIME.";".$EXEC."\n";
	$ps_diff_result = $ps_diff_result.$process;
}
print STDOUT $ps_diff_result;



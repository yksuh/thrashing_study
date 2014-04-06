#!/bin/perl
$command = "sudo su db2 -c \"source /data/db2/sqllib/db2cshrc;db2 connect to research;db2pdcfg -flushbp -db research;\"";
$output = `$command`;
print $output;


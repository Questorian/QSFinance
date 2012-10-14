#-------------------------------------------------------------------------
#
# LanguageCourse.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# LanguageCourse.pl: generate Questor Language Coure Receipts for Farley B
#
# Project:	
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2008-12-19T20:51:47
# History:
#		v0.2 - 
#		v0.1 - 2008-12-19 - initial version created
#            
#-------------------------------------------------------------------------
$svn_rev='$Rev: 110 $';
$svn_id='$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate='$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';
#-------------------------------------------------------------------------
# (c)1997 - 2008, QuestorSystems.com, All rights reserved.
# Gempenstrasse 46, CH-4053, Basel, Switzerland
# telephone:+41 79 285 6482,  email:developer@QuestorSystems.com
#-------------------------------------------------------------------------

use strict;
use warnings;

#use Readonly
use DateTime;
#use Getopt::Long;
#use Config::Std;
#use Config::Tiny;


# call the main function
LanguageCourse(@ARGV);




### Main Function ###
# Usage     : LanguageCourse()
# Purpose   : LanguageCourse -> main function  - drives program
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub LanguageCourse
{
my ($v)=@_;

	my @billing_days;
	
	# start with the Datetime object
	my $dt = DateTime->new( year => 2009, month => 1, day => 1 );
	for (my $i =0; $i < 366 ; $i ++){ 
		print "today is ", $dt->ymd, " and the day is: ", $dt->day_abbr, "\n"; 
		$dt->add ( days => 1 );
		if($dt->day_abbr eq 'Mon' ){
			# add the date to our billing days
			push(@billing_days, $dt);

		}

	}
		

		# now lets play all those dates back
		foreach my $dt (@billing_days) {
			print "we have a day: ", $dt->ymd, " and the day-of-the-week is: ", $dt->day_name, "\n";
			}

    return;
}



### INTERFACE SUB/INTERNAL UTILITY ###
# Usage     : ???
# Purpose   : ???
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub s
{
my ($v)=@_;

    
    return;
}

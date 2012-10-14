#-------------------------------------------------------------------------
#
# expense.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# expense.pl: whatever
#
# Project:
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2008-11-28T01:48:33
# History:
#		v0.2 -
#		v0.1 - 2008-11-28 - initial version created
#
#-------------------------------------------------------------------------
$svn_rev = '$Rev: 110 $';
$svn_id  = '$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate =
  '$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';

#-------------------------------------------------------------------------
# (c)1997 - 2008, QuestorSystems.com, All rights reserved.
# Gempenstrasse 46, CH-4053, Basel, Switzerland
# telephone:+41 79 285 6482,  email:developer@QuestorSystems.com
#-------------------------------------------------------------------------

use strict;
use warnings;

use DBI;
use Carp;
use Config::Tiny;

#use DateTime;
#use Getopt::Long;

# ini file - we get the DBI connection parameters (connection string) out of this file
my $ini = "v:/_data/ini/QBase.ini";

# $ini_section - change this to the name of the section you want loaded in the ini file
my $ini_section = "Production";

# a STANDARD query that will work on any installation - simply query the master database
my $query_1 = q{
insert into 
	expense_items
	(amount, category, description)
values
	( ?, ?, ?)

};

my $query_2 = q{
  exec dbo.apt_InsertExpenseItem2  @amount = ?,  @category = ?, @description = ?
};


# call the main function
expense(@ARGV);

### Main Function ###
# Usage     : expense()
# Purpose   : expense -> main function  - drives program
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub expense {
    my ($v) = @_;

    #check the ini file exist - get the DB location information
    if ( -f $ini ) {
        print "found existing ini file: $ini";
    }
    else {
        croak "unable to find ini file: $ini\n";
    }

    # create a config object
    my $config = Config::Tiny->new();

    # open the config file
    $config = Config::Tiny->read($ini);

    #print out the data we want...
    print "\nDumping out INI file parameters:\n";
    print "----------------------------------\n";
    print "persona           : $config->{$ini_section}->{persona}\n";
    print "server            : $config->{$ini_section}->{server}\n";
    print "database          : $config->{$ini_section}->{database}\n";
    print "trusted connection: $config->{$ini_section}->{trusted_connection}\n";
    print "----------------------------------\n";

    # DBI::ADO connectino string
    my $ms_con_str = "dbi:ADO:Driver={SQL Native Client};
   Server=$config->{$ini_section}->{server};
   Database=$config->{$ini_section}->{database};
   trusted_connection=$config->{$ini_section}->{trusted_connection}";

    # database handel - connect to the database
    my $dbh = DBI->connect( $ms_con_str,,, { TimeOut => 5 } )
      or die $DBI::errstr;

    # let's get some tracing on this
    DBI->trace( 1, "c:\\temp\\dbitrace.txt" );

    # statement handel - prepare the statement
    my $sth = $dbh->prepare($query_2);

    # execute the statement handel
    $sth->execute( 36.23, 'SUB', 'Choco biccies' );
    # $sth->execute( );

    # get the unique id number - SET @ExpenseID = SCOPE_IDENTITY()
    my $sth2 = $dbh->prepare('SELECT @@Identity');
    my $id = $sth2->execute();
    print "Folio Number: $id\n";

    # close the statement handle
    $sth->finish;

    # disconnect and exit
    $dbh->disconnect;

    print "this is the end...\n";

    return;
}

sub display {
    my ($v) = @_;

    # temp for now
    my $sth;

    # iterate each row - dump quick and dirty
    while ( my @row = $sth->fetchrow_array ) {
        print "@row\n";
    }

}

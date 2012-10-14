#-------------------------------------------------------------------------
#
# LanguageInvGen.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# LanguageInvGen.pl: A scritp to generate invoices for langauge tuition for
#       Questor Systems
#
# Project:
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2009-05-29T19:09:29
# History:
#		v0.2 -
#		v0.1 - 2009-05-29 - initial version created
#
#-------------------------------------------------------------------------
$svn_rev = '$Rev: 110 $';
$svn_id  = '$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate =
  '$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';

#-------------------------------------------------------------------------
# (c)1997 - 2009, QuestorSystems.com, All rights reserved.
# Gempenstrasse 46, CH-4053, Basel, Switzerland
# telephone:+41 79 285 6482,  email:developer@QuestorSystems.com
#-------------------------------------------------------------------------

use strict;
use warnings;
use DateTime;
use Config::Tiny;
use Carp;
# use File::Copy;
use Win32::OLE;

#use Readonly
#use Getopt::Long;
#use Config::Std;

# global variables
my $ini = 'v:\\_data\\ini\\LanguageInvGen.ini';
my $config;
my $debug = 0;
my $language_code;
my @holidays;

# call the main function
LanguageInvGen(@ARGV);

### Main Function ###
# Usage     : LanguageInvGen()
# Purpose   : LanguageInvGen -> main function  - drives program
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub LanguageInvGen {
    my ($year) = shift;

    $language_code = shift;

    #total for all 12 months of tuition fees for this year
    my $total;

    # sanity check
    if (   $language_code ne 'DE'
        && $language_code ne 'FR' )
    {
        croak
"unrecognised language code given: $language_code - check ini file $ini";
    }

    # the year
    if ( $year < 2005 || $year > 2015 ) {
        croak "year is probably out of range? [$year]\n";
    }
    print "Invoices for year: $year\n";

    # get parameters from the INI file
    open_ini();

    # opent the holidays file - make sure no-courses during a holiday!
    print "this is after - open_ini file...\n";
    load_holidays();

    # open the log file
    my $summary = '>>'
      . $config->{_}->{OutputDirectory}
      . "\\Language-Monthly-Subtotals.txt";
    open( LOG, $summary )
      or die "unable to open Language Financial summary file: $summary";

    for ( my $month = 1 ; $month <= 12 ; $month++ ) {
        my $cost = ProcessMonth( $year, $month );

        # update the log for the monthly expense payout
        print LOG "$year-$month: $cost\n";
        $total += $cost;
    }

    # print the total for the year to the log
    print LOG "\n\nTotal Language tuition fees for $year: $total\n";
    close(LOG);

    return;
}

### INTERNAL UTILITY ###
# Usage     : ???
# Purpose   : Generates the invoice file for the
# Returns   : cost of the month raised by the invoice that it has generated
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub ProcessMonth {
    my ( $year, $month ) = @_;

    my @days;

    # create a datetime object corresponding to parameters
    my $day = 1;
    my $dt  = DateTime->new(
        year  => $year,
        month => $month,
        day   => $day,
    );

    printf "Creating Invoice for: %s $year\n", $dt->month_name;

    do {

        # check to see if this is one of our course days,
        # and if so print it out
        if ( is_course_day($dt) && ( !is_holiday($dt) ) ) {

            # we have a genuine course day folks!
            push( @days, sprintf( "%s", $dt->ymd ) );
        }

        # increment the day
        $day++;

        $dt->add( { days => 1 } );

    } until ( $dt->month != $month );

    # now we actually raise the invoice
    RaiseInvoice( $year, $month, @days );

}

### INTERFACE SUB/INTERNAL UTILITY ###
# Usage     : ???
# Purpose   : ???
# Returns   : total of the invoice - so that it can be logged and tracked
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub RaiseInvoice {
    my ( $year, $month, @days ) = @_;

    # generate the new excel spreadsheet
    my $target =
      $config->{_}->{OutputDirectory}
      . sprintf( "\\LanguageTuition-$language_code-$year-%.02d.xlsx", $month );
    my $cost;

    print "saving file to $target\n";

    #create the new invoice file
    # copy( $config->{$language_code}->{template}, $target )
    #  or die "uable to create file $target from template";

    # initiate row/column vars
    my $row       = $config->{$language_code}->{Row};
    my $column    = $config->{$language_code}->{Column};
    my $endcolumn = $config->{$language_code}->{EndColumn};

    # crack-up a copy of Excel

    my $excel = Win32::OLE->GetActiveObject('Excel.Application');

    unless ($excel) {
        $excel = new Win32::OLE('Excel.Application')

          # $excel = new Win32::OLE('Excel.Application', \&QuitApp)
          or die " Could not create Excel Application object ";
    }

    # $excel->->Display();
    $excel->{Visible} = 1;

    # Open File and Worksheet
    my $workbook =
      $excel->Workbooks->Open( $config->{$language_code}->{template} )
      ;    # open Excel file
    my $worksheet = $workbook->Worksheets(1);

    # set the invoice no
    my $range = $worksheet->Range(
"$config->{$language_code}->{MonthNameColumn}$config->{$language_code}->{MonthNameRow}"
    );
    $range->{Value} = $year . '-' . $month . "-1";

    foreach my $day (@days) {
        print "Course Day => $day \n";

        # add to spread sheet
        my $range = $worksheet->Range("$column$row:$endcolumn$row");
        $range->{Value} = [
            $day,
            $config->{$language_code}->{LessonDuration},
            $config->{$language_code}->{HourlyRate}
        ];

        # calculate the cost for this session
        $cost +=
          $config->{$language_code}->{LessonDuration} *
          $config->{$language_code}->{HourlyRate};

        # move on to the next row
        $row++;
    }

    $workbook->SaveAs($target);

    # close excel
    $excel->Quit();

    $cost;

}
### INTERFACE SUB/INTERNAL UTILITY ###
# Usage     : ???
# Purpose   : ???
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub open_ini {
    my ($v) = @_;

    #check the ini file exist - get the DB location information
    if ( -f $ini ) {
        print "found existing ini file: $ini";
    }
    else {
        croak "unable to find ini file: $ini\n";
    }

    # create a config object
    $config = Config::Tiny->new();

    # open the config file
    $config = Config::Tiny->read($ini);

    if ($debug) {

        tbd();

    }

}

### INTERFACE SUB/INTERNAL UTILITY ###
# Usage     : ???
# Purpose   : ???
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub is_holiday {
    my ($dt) = @_;

    # default is that it is not a holiday
    my $ret = 0;

    # first check from our list of official holidays
    foreach my $h (@holidays) {
        if ( $h == $dt ) {
            $ret = 1;
            print "course is on a holiday: $dt->ymd\n";
        }
    }

    # anything close to Christmas until end of year is considered a holiday here
    if (   ( $dt->month == 12 )
        && ( $dt->day > 21 ) )
    {
        $ret = 1;
    }

    $ret;

}
### INTERNAL UTILITY ###
# Usage     : ???
# Purpose   : returns true if the days of the week is a course day as defined
#               in the INI file value CourseDays - comma seperated list
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub is_course_day {
    my ($dt) = @_;

    # FALSE by default
    my $ret = 0;

    # load the comma seperated list of days into an array
    my @days_of_week = split /,/, $config->{$language_code}->{CourseDays};
    foreach my $dow (@days_of_week) {
        if ( $dt->dow == $dow ) {
            $ret = 1;
        }
    }

    return $ret;

}
### INTERNAL UTILITY ###
# Usage     : ???
# Purpose   : ???
# Returns   : ???{
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub load_holidays {
    my ($v) = @_;

    if ( -f $config->{_}->{HolidaysFile} ) {
        print "file exists!\n";
    }
    else {
        croak "unable to find ini file: \n";
    }

    # load in the holidays listed in the file
    open( HOLS, $config->{_}->{HolidaysFile} )
      or die "unable to open holiday file; $config->{_}->{HolidaysFile}";

    while (<HOLS>) {

        my ( $date, $type, $description ) = split /:/;
        print "found holiday: $date\n";

        my ( $year, $month, $day ) = split /-/, $date;

        # create a datetime object for later comparison
        push(
            @holidays,
            DateTime->new(
                year  => $year,
                month => $month,
                day   => $day
            )
        );

    }

}

sub tbd() {
    my ($v) = @_;

    die "TBD: function not impletemented yet - please try later...!\n";

}

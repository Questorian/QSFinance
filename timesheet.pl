
use strict;
use warnings;

use Win32::OLE;
use Carp;
use Config::Tiny;
use Questor::Win32;
use Questor;

use DateTime;

# ini file - we get the DBI connection parameters (connection string) out of this file
my $ini = "v:/_data/ini/Questor.ini";

# $ini_section - change this to the name of the section you want loaded in the ini file
my $ini_section = "timesheet";

# global variables
my $dbh;    # dbi handle for queries used throughout the program
my $config;
my $template;
my $workdir;
my $offset = 10;    # because invooice raised in it's following month
my $terms = 29;
my $month;
my $year;
my $invoice_no = '60484';
my $quantity;

my $signed_timesheet;
my $new_invoice;
my $pdf_printer;

# calculate DateTime parameters for invoice
my $period = DateTime->now()->subtract( days => $offset );
my $due = DateTime->now()->add( days => $terms );
$month = $period->month_name;
$year  = $period->year();

get_config();
generate_email();
generate_reminder();


sub generate_reminder
{

    print "QuestorSystems payment due: Invoice $invoice_no - Option Consulting [waiting-for][due: " . $due->ymd . "]\n";


}


sub generate_email {
    my ($attachments_ref) = @_;

    print "Email text template: $config->{$ini_section}->{email_body_file}\n";

    # first get all the parameters we will need from the ini file
    olmail(
        {

            to      => $config->{$ini_section}->{email_to},
            cc      => $config->{$ini_section}->{email_cc},
            subject => $config->{$ini_section}->{email_subject}
                . " $invoice_no - $month $year",
            body_file   => $config->{$ini_section}->{email_body_file},
            attachments => $attachments_ref,
            timestamp   => 1,

        }
    );

    # the email should be ready to send

}

sub QuitApp {
    my ($object) = @_;
    $object->Quit();
}

sub get_config

{
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

    #print out the data we want...
    print "\nDumping out INI file parameters:\n";
    print "----------------------------------\n";
    print "persona           : $config->{$ini_section}->{persona}\n";
    print "server            : $config->{$ini_section}->{server}\n";
    print "database          : $config->{$ini_section}->{database}\n";
    print
        "trusted connection: $config->{$ini_section}->{trusted_connection}\n";
    print "----------------------------------\n";

    # get other values
    $template    = $config->{$ini_section}->{invoice_template};
    $workdir     = $config->{$ini_section}->{workdir};
    $pdf_printer = $config->{$ini_section}->{pdf_printer};

}

#-------------------------------------------------------------------------
#
# test_CreateOutlookTask.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# test_CreateOutlookTask.pl: whatever
#
# Project:
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2008-12-02T17:51:12
# History:
#		v0.2 -
#		v0.1 - 2008-12-02 - initial version created
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
use Win32::OLE;
use Win32::OLE::Const 'Microsoft Outlook';
use Questor;

#use Readonly
#use DateTime;
#use Getopt::Long;
#use Config::Std;
#use Config::Tiny;

# call the main function
test_CreateOutlookTask2(@ARGV);
exit(0);

#
#   VBCode to do the job
#
#   Set myOlApp = CreateObject("Outlook.Application")
#    Set myItem = myOlApp.CreateItem(3)
#    Set myArgs = WScript.Arguments
#
#    if myArgs.Count > 0 then
#      myItem.Categories = "@" + myArgs(0)
#      if myArgs.Count > 1 then
#        myItem.Subject = myArgs(1)
#        if myArgs.Count > 2 Then
#          myItem.DueDate = myArgs(2)
#        End If
#        myItem.Save
#      End if
#    End if
#
#    if myArgs.Count < 2 then myItem.Display
#    'end @.vbs
#

sub test_CreateOutlookTask2 {
    my ($args) = @_;

    # testing the function call

    my $task = oltask(
        {
            subject    => 'Send Invoice to talisman',
            duedate    => 30,
            categories => 'catalyst;Punny;ZAG-ZAG',
              body => "This is  really cool stuff man! We have got it all now!",
            display    => 0,

        }
    );

}

### Main Function ###
# Usage     : test_CreateOutlookTask()
# Purpose   : test_CreateOutlookTask -> main function  - drives program
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub test_CreateOutlookTask {
    my ($v) = @_;

    # create Outlook onject
    my $outlook  = new Win32::OLE('Outlook.Application');
    my $taskitem = $outlook->CreateItem(olTaskItem);
    die "Can't create TaskItem, $!, $^E" unless ($taskitem);

    # lets make it visible
    $taskitem->Display();

    # set the subject
    $taskitem->{Subject} = "XMAS time baby!!";

    # set the due date
    $taskitem->{DueDate} = '2008-12-25';

    # set the categories - comma seperated  list
    $taskitem->{Categories} = 'catalyst;Expert';

    # save it
    $taskitem->Save();

    return;
}

### INTERFACE SUB/INTERNAL UTILITY ###
# Usage     : ???
# Purpose   : ???
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub s {
    my ($v) = @_;

    return;
}

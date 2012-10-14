use Win32::OLE;
$file = shift || "C:\\temp\\MyTest.xls";
$excel = Win32::OLE->GetActiveObject('Excel.Application');
unlink($file) if (-e $file);
unless($excel)
{
    $excel = new Win32::OLE('Excel.Application', \&QuitApp) 
                 or die "Could not create Excel Application object";
}

$excel->{Visible} = 1;
$excel->{SheetsInNewWorkBook} = 1;
$workbook = $excel->Workbooks->Add();
$worksheet = $workbook->Worksheets(1);
$worksheet->{Name} = "Directory listing";

@files = glob(shift || '*');

$range=$worksheet->Range('A1:C1');
$range->{Value} = ['Filename', 'Size', 'Time'];

my $cellrow = 2;

foreach $file (@files)
{
    my ($size,$mtime) = (stat($file))[7,9];
    $range=$worksheet->Range(sprintf("%s%d:%s%d",'A',$cellrow,'C',$cellrow));
    $range->{Value} = [$file,$size,scalar localtime $mtime];
    $cellrow++;
}
$workbook->SaveAs($file);

sub QuitApp
{
    my ($object) = @_;
    $object->Quit();
}


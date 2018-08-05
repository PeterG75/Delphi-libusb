  (* Example ListDevs translated to Delphi by Greg Bayes
    Version 1
    Changed  23/07/2018
    - idVendor and Id Product to hex values
    - libusb example program to list devices on the bus

   Licence MIT                               *)
 unit main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms,
  FMX.Graphics, FMX.Dialogs,  FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Memo, libusb1, FMX.Edit, FMX.ScrollBox;

type
  TfmMain = class(TForm)
    ToolBar1: TToolBar;
    Label5: TLabel;
    Memo1: TMemo;
    StyleBook1: TStyleBook;
    procedure FormCreate(Sender: TObject);
  private
    procedure getdev(dev: plibusb_device);

  var
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.fmx}

procedure TfmMain.getdev(dev: plibusb_device);
var
  j,r: integer;
  desc: libusb_device_descriptor;
  path: array [0 .. 8] of byte;
begin
  r := libusb_get_device_descriptor(dev, @desc);
  if r <> 0 then
  begin
    Memo1.lines.add('failed to get device descriptor');
    exit;
  end
  else
  begin
    Memo1.lines.add('No of possible configurations : ' +
      inttostr(desc.bNumConfigurations) + '  Device Class : ' +
      inttostr(desc.bDeviceClass));
    Memo1.lines.add('Bus : ' + inttostr(libusb_get_bus_number(dev)) +
      '  Device : ' + inttostr(libusb_get_device_address(dev)) +
      '   Vender ID : ' + inttohex(desc.idVendor) + '  Product ID : ' +
      inttohex(desc.idProduct));
    r := libusb_get_port_numbers(dev, @path, sizeof(path));
    if r > 0 then
    begin
      for j := 1 to r - 1 do
      begin
        Memo1.lines.add('path:  ' + inttostr(path[j]));
      end;
    end;
    Memo1.lines.add
      ('----------------------------------------------------------------');
  end;
end;

procedure TfmMain.FormCreate(Sender: TObject);
var
  i, count: ssize_t;
  r: integer;
  devs: pplibusb_device;
  arrdev: array of plibusb_device;
  context: plibusb_context;
begin
  // List devices
  Memo1.lines.clear;
  context := nil; // declare the pointer to null
  r := libusb_init(context);
  if r <> 0 then
  begin
    Memo1.lines.add('Cannot initialize the DLL Device Value ' + inttostr(r) +
      'is less than 0');
    exit;
  end
  else
  begin
    Memo1.lines.add('DLL Initialized  - Device is connected');
  end;

  Memo1.lines.add('');
  count := libusb_get_device_list(context, @devs);
  //set the array's size to the count
 setlength(arrdev, count);
libusb_free_device_list(devs, 1); // we now know how many devices there are

  if count < 1 then
  begin
    Memo1.lines.add('No devices found ');
    exit;
  end
  else
  begin

    libusb_get_device_list(context, @arrdev); // set new devicelist with dev

    Memo1.lines.add('USB Devices found : ' + inttostr(count));
    Memo1.lines.add('');
    Memo1.lines.add('Bus   Device   VID id   PID id   Paths');
    Memo1.lines.add
      ('-------------------------------------------------------------------');
    for i := 0 to count - 1 do
    begin
      Memo1.lines.add('USB device on system no :  ' + inttostr(i + 1));
     // getdev(devs^);
      getdev(arrdev[i]);
    end;
    (*Cannot use the  function free_ device_list with an array of Plibusb_devices
     so have to de_ref each Plibdevice one by one from last to first *)
       //  libusb_free_device_list(devs,1);
    for I  := high(arrdev) to low(arrdev) do
    libusb_unref_device(arrdev[i]);
    libusb_exit(context);
  end;
end;

end.

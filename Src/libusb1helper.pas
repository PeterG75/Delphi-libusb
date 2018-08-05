(*Developed By Greg Bayes
  This is a helper library to access more information.
  Changed 22/07/2018
  Added the errorcode function as the libusb_error_code type
  ass it could not be accessed directly *)
unit libusb1helper;

interface
uses libusb1,System.SysUtils,
{$IF DECLARED (FiremonkeyVersion)}
{$DEFINE HAS_FMX}
FMX.Dialogs,System.Variants;
{$ELSE}
{$DEFINE HAS_VCL}
 System.Variants;
{$ENDIF}


function Getlibusbdeviceclass(dcno:uint8):string;
function Getlibusbdevicetype(dcno:uint8):string;
function endpointdirection(epno:uint8):string;
function Getlibusbcapabilitytype(dcno:uint8):string;
function Errorcode(name:string):integer;


implementation

function Getlibusbdeviceclass(dcno:uint8):string;
var
no:integer;
begin
result:= 'Undefined';
no:= dcno;
case no of
 0:result:='LIBUSB_CLASS_PER_INTERFACE';
 1: result:='LIBUSB_CLASS_AUDIO' ;
 2:  result:='LIBUSB_CLASS_COMM';
 3: result:= 'LIBUSB_CLASS_HID';
 5: result:= 'LIBUSB_CLASS_PHYSICAL';
 7: result:= 'LIBUSB_CLASS_PRINTER';
 6: result:='LIBUSB_CLASS_PTP or LIBUSB_CLASS_IMAGE';
 8: result:='LIBUSB_CLASS_MASS_STORAGE';
 9: result:='LIBUSB_CLASS_HUB';
 10:result:='LIBUSB_CLASS_DATA';
 11:result:='LIBUSB_CLASS_SMART_CARD';
 13 :result:='LIBUSB_CLASS_CONTENT_SECURITY ';
 14:result:='LIBUSB_CLASS_VIDEO';
 15:result:='LIBUSB_CLASS_PERSONAL_HEALTHCARE';
 220:result:='LIBUSB_CLASS_DIAGNOSTIC_DEVICE';
 224:result:='LIBUSB_CLASS_WIRELESS';
 239:result:='LIBUSB_CLASS_APPLICATION';
 255:result:='LIBUSB_CLASS_VENDOR_SPEC';
 end;
end;

//bmdescriptortype
function Getlibusbdevicetype(dcno:Uint8):string;
var
no:integer;
begin
result:= 'Undefined';
no:= dcno;
case no of
 1: result:='LIBUSB_DT_DEVICE';
 2:result:='LIBUSB_DT_CONFIG';
 3:result:='LIBUSB_DT_STRING';
 4:result:='LIBUSB_DT_INTERFACE';
 5:result:='LIBUSB_DT_ENDPOINT';
 15:result:='LIBUSB_DT_BOS';
 16:result:='LIBUSB_DT_DEVICE_CAPABILITY';
 33:result:='LIBUSB_DT_HID';
 34:result:= 'LIBUSB_DT_REPORT';
 36:result:='LIBUSB_DT_PHYSICAL';
 41:result:='LIBUSB_DT_HUB';
 42:result:='LIBUSB_DT_SUPERSPEED_HUB';
 48:result:='LIBUSB_DT_SS_ENDPOINT_COMPANION';
 end;
 end;
//bmDevCapibilitytype
function Getlibusbcapabilitytype(dcno:Uint8):string;
var
no:integer;
begin
result:= 'Undefined';
no:= dcno;
case no of
 1:result:='LIBUSB_BT_WIRELESS_USB_DEVICE_CAPABILITY';
 2:result:='LIBUSB_BT_USB_2_0_EXTENSION';
 3:result:='LIBUSB_BT_SS_USB_DEVICE_CAPABILITY';
 4:result:=' LIBUSB_BT_CONTAINER_ID';

 end;
 end;

//bmAttributes speed mode
function Getlibusbspeed(dcno:Uint8):string;
var
no:integer;
begin
result:= 'Undefined';
no:= dcno;
case no of
1:result:='LIBUSB_LOW_SPEED_OPERATION';
2:result:='LIBUSB_FULL_SPEED_OPERATION';
3:result:='LIBUSB_HIGH_SPEED_OPERATION';
8:result:='LIBUSB_SUPER_SPEED_OPERATION';
  end;
 end;


function Getlibusboperatingspeed(dcno:Uint8):string;
var
no:integer;
begin
result:= 'Undefined';
no:= dcno;
case no of
0:result:='LIBUSB_SPEED_UNKNOWN';
1:result:='LIBUSB_SPEED_LOW';
2:result:='LIBUSB_SPEED_FULL';
3:result:='LIBUSB_SPEED_HIGH';
4:result:='LIBUSB_SPEED_SUPER';
5:result:='LIBUSB_SPEED_SUPER_PLUS';
  end;
 end;

function endpointdirection(epno:uint8):string;
var
no:integer;
begin
no:= epno;
case no of
128:result:='LIBUSB_ENDPOINT_IN';
0:result:='LIBUSB_ENDPOINT_OUT';
 end;
end;


function ExtractbitsRl(value,startbits,bitlength:integer):integer;
begin
result:= ((value shr(9-startbits)-bitlength) and ((1 shl bitlength) -1));
end;


 function Errorcode(name:string):integer;
 begin
 //set for calling in app
 if name =  'LIBUSB_SUCCESS' then  result := 0;
  if name = 'LIBUSB_ERROR_IO' then result := -1;
  (** Input/output error *)
  if name  = 'LIBUSB_ERROR_INVALID_PARAM'then result := -2;
  (** Invalid parameter *)
  if name = 'LIBUSB_ERROR_ACCESS' then Result:= -3;
  (** Access denied (insufficient permissions) *)
  if name = 'LIBUSB_ERROR_NO_DEVICE' then Result:= -4;
  (** No such device (it may have been disconnected) *)
  if name = 'LIBUSB_ERROR_NOT_FOUND' then Result:= -5;
  (** Entity not found *)
  if name = 'LIBUSB_ERROR_BUSY' then Result:= -6;
    (** Resource busy *)
  if name = 'LIBUSB_ERROR_TIMEOUT' then Result:= -7;
  (** Operation timed out *)
  if name = 'LIBUSB_ERROR_OVERFLOW' then Result:= -8;
  (** Overflow *)
  if name = 'LIBUSB_ERROR_PIPE' then Result:= -9;
  (** Pipe error *)
  if name = 'LIBUSB_ERROR_INTERRUPTED' then Result:= -10;
  (** System call interrupted (perhaps due to signal) *)
  if name = 'LIBUSB_ERROR_NO_MEM' then Result:= -11;
  (** Insufficient memory *)
  if name = 'LIBUSB_ERROR_NOT_SUPPORTED' then Result:= -12;
  (** Operation not supported or unimplemented on this platform *)
  if name = 'LIBUSB_ERROR_OTHER' then Result:= -99 ;
  end;

 end.

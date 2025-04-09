unit usb_device;

interface
//�����ѹ���ֵ
const
POWER_LEVEL_NONE	 = 0;	//�����
POWER_LEVEL_1V8		 = 1;	//���1.8V
POWER_LEVEL_2V5		 = 2;	//���2.5V
POWER_LEVEL_3V3		 = 3;	//���3.3V
POWER_LEVEL_5V0		 = 4;	//���5.0V

//�����ʼ��LIN��ʼ����������
type
PDEVICE_INFO = ^DEVICE_INFO;
DEVICE_INFO = record
  FirmwareName:Array[0..31] Of Byte;    //�̼������ַ���
  BuildDate:Array[0..31] Of Byte;       //�̼�����ʱ���ַ���
  HardwareVersion:LongWord;             //Ӳ���汾��
  FirmwareVersion:LongWord;             //�̼��汾��
  SerialNumber:Array[0..2] Of LongWord; //���������к�
  Functions:LongWord;                   //��������ǰ�߱��Ĺ���
end;

function USB_ScanDevice(pDevHandle:PLongWord):Integer; stdcall;
function USB_OpenDevice(DevHandle:LongWord):Boolean; stdcall;
function USB_CloseDevice(DevHandle:LongWord):Boolean; stdcall;
function DEV_GetDeviceInfo(DevHandle:LongWord;pDevInfo:PDEVICE_INFO; pFunctionStr:PByte):Boolean; stdcall;
function DEV_EraseUserData(DevHandle:LongWord):Boolean; stdcall;
function DEV_WriteUserData(DevHandle,OffsetAddr:LongWord;pWriteData:PByte;DataLen:LongWord):Boolean; stdcall;
function DEV_ReadUserData(DevHandle,OffsetAddr:LongWord;upReadData:PByte;DataLen:LongWord):Boolean; stdcall;
function DEV_SetPowerLevel(DevHandle:LongWord;PowerLevel:Byte):Boolean; stdcall;

implementation
function USB_ScanDevice;external 'USB2XXX.dll' name 'USB_ScanDevice';
function USB_OpenDevice;external 'USB2XXX.dll' name 'USB_OpenDevice';
function USB_CloseDevice;external 'USB2XXX.dll' name 'USB_CloseDevice';
function DEV_GetDeviceInfo;external 'USB2XXX.dll' name 'DEV_GetDeviceInfo';
function DEV_EraseUserData;external 'USB2XXX.dll' name 'DEV_EraseUserData';
function DEV_WriteUserData;external 'USB2XXX.dll' name 'DEV_WriteUserData';
function DEV_ReadUserData;external 'USB2XXX.dll' name 'DEV_ReadUserData';
function DEV_SetPowerLevel;external 'USB2XXX.dll' name 'DEV_SetPowerLevel';
end.

unit usb2iic;

interface

const
//���庯�����ش������
IIC_SUCCESS             = (0);   //����ִ�гɹ�
IIC_ERR_NOT_SUPPORT     = (-1);  //��������֧�ָú���
IIC_ERR_USB_WRITE_FAIL  = (-2);  //USBд����ʧ��
IIC_ERR_USB_READ_FAIL   = (-3);  //USB������ʧ��
IIC_ERR_CMD_FAIL        = (-4);  //����ִ��ʧ��
IIC_ERR_PARA_ERROR      = (-5);  //�����������
//����IIC�������ش������
IIC_ERROR_SUCCESS     = 0;   //�����ɹ�
IIC_ERROR_CHANNEL     = 1;   //��ͨ����֧�ָú���
IIC_ERROR_BUSY        = 2;   //����æ
IIC_ERROR_START_FAILD = 3;   //��������ʧ��
IIC_ERROR_TIMEOUT     = 4;   //��ʱ
IIC_ERROR_NACK        = 5;   //�ӻ���Ӧ��
IIC_ERROR_PEC         = 6;   //PECУ��ʧ��

//�����ʼ��IIC����������
type
PIIC_CONFIG = ^IIC_CONFIG;
IIC_CONFIG = record
  ClockSpeedHz:LongWord;    //IICʱ��Ƶ��:��λΪHz
  OwnAddr:Word;             //USB2XXXΪ�ӻ�ʱ�Լ��ĵ�ַ
  Master:Byte;              //����ѡ�����:0-�ӻ���1-����
  AddrBits:Byte;            //�ӻ���ַģʽ��7-7bitģʽ��10-10bitģʽ
  EnablePu:Byte;            //ʹ������оƬ�ڲ��������裬����ʹ�ܣ���I2C�����ϱ������������
end;

//��������
function IIC_Init(DevHandle:LongWord;IICIndex:LongWord; pConfig:PIIC_CONFIG):Integer; stdcall;
function IIC_GetSlaveAddr(DevHandle:LongWord;IICIndex:LongWord;pSlaveAddr:PWord);:Integer; stdcall;
function IIC_WriteBytes(DevHandle:LongWord;IICIndex:LongWord;SlaveAddr:Word;pWriteData:PByte;WriteLen,TimeOutMs:LongWord):Integer; stdcall;
function IIC_ReadBytes(DevHandle:LongWord;IICIndex:LongWord;SlaveAddr:Word;pReadData:PByte;ReadLen,TimeOutMs:LongWord):Integer; stdcall;
function IIC_WriteReadBytes(DevHandle:LongWord;IICIndex:LongWord;SlaveAddr:Word;pWriteData:PByte;WriteLen:LongWord;pReadData:PByte;ReadLen,TimeOutMs:LongWord):Integer; stdcall;

function IIC_SlaveWriteBytes(DevHandle:LongWord;IICIndex:LongWord;pWriteData:PByte;WriteLen,TimeOutMs:LongWord):Integer; stdcall;
function IIC_SlaveReadBytes(DevHandle:LongWord;IICIndex:LongWord;pReadData:PByte;TimeOutMs:LongWord):Integer; stdcall;
function IIC_SlaveWriteRemain(DevHandle:LongWord;IICIndex:LongWord):Integer; stdcall;

function IIC_WriteBytesOfEvent(DevHandle:LongWord;IICIndex:LongWord;SlaveAddr:Word;pWriteData:PByte;WriteLen,EventPin:LongWord;EventType:Byte;TimeOutOfEventMs:LongWord):Integer; stdcall;
function IIC_ReadBytesOfEvent(DevHandle:LongWord;IICIndex:LongWord;SlaveAddr:Word;pReadData:PByte;ReadLen,EventPin:LongWord;EventType:Byte;TimeOutOfEventMs:LongWord):Integer; stdcall;
function IIC_WriteReadBytesOfEvent(DevHandle:LongWord;IICIndex:LongWord;SlaveAddr:Word;pWriteData:PByte;WriteLen:LongWord;pReadData:PByte;ReadLen,EventPin:LongWord;EventType:Byte;TimeOutOfEventMs:LongWord):Integer; stdcall;

function SMBUS_Init(DevHandle:LongWord;IICIndex:LongWord;ClockSpeedHz:LongWord;EnablePu:Byte):Integer; stdcall;
function SMBUS_QuickCommand(DevHandle:LongWord;IICIndex:LongWord;SlaveAddr:Word;WriteReadFlag:Byte):Integer; stdcall;
function SMBUS_WriteByte(DevHandle:LongWord;IICIndex:LongWord;SlaveAddr:Word;Data,WithPEC:Byte):Integer; stdcall;
function SMBUS_ReadByte(DevHandle:LongWord;IICIndex:LongWord;SlaveAddr:Word;pData:PByte;WithPEC:Byte):Integer; stdcall;
function SMBUS_WriteByteProtocol(DevHandle:LongWord;IICIndex:LongWord;SlaveAddr:Word;CommandCode, Data,WithPEC:Byte):Integer; stdcall;
function SMBUS_WriteWordProtocol(DevHandle:LongWord;IICIndex:LongWord;SlaveAddr:Word;CommandCode:Byte; Data:Word;WithPEC:Byte):Integer; stdcall;
function SMBUS_ReadByteProtocol(DevHandle:LongWord;IICIndex:LongWord;SlaveAddr:Word;CommandCode:PByte; pData:PByte,WithPEC:Byte):Integer; stdcall;
function SMBUS_ReadWordProtocol(DevHandle:LongWord;IICIndex:LongWord;SlaveAddr:Word;CommandCode:PByte; pData:PWord;WithPEC:Byte):Integer; stdcall;
function SMBUS_ProcessCall(DevHandle:LongWord;IICIndex:LongWord;SlaveAddr:Word;CommandCode:PByte; WriteData:Word;pReadData:PWrod;WithPEC:Byte):Integer; stdcall;
function SMBUS_BlockWrite(DevHandle:LongWord;IICIndex:LongWord;SlaveAddr:Word;CommandCode:PByte; pWriteData:PByte;WriteCount:LongWord;WithPEC:Byte):Integer; stdcall;
function SMBUS_BlockRead(DevHandle:LongWord;IICIndex:LongWord;SlaveAddr:Word;CommandCode:PByte; pReadData:PByte;pReadCount:PLongWord;WithPEC:Byte):Integer; stdcall;
function SMBUS_BlockProcessCall(DevHandle:LongWord;IICIndex:LongWord;SlaveAddr:Word;CommandCode:PByte; pWriteData:PByte;WriteCount:LongWord; pReadData:PByte;pReadCount:PLongWord;WithPEC:Byte):Integer; stdcall;



implementation
function IIC_Init;external 'USB2XXX.dll' name 'IIC_Init';
function IIC_GetSlaveAddr;external 'USB2XXX.dll' name 'IIC_GetSlaveAddr';
function IIC_WriteBytes;external 'USB2XXX.dll' name 'IIC_WriteBytes';
function IIC_ReadBytes;external 'USB2XXX.dll' name 'IIC_ReadBytes';
function IIC_WriteReadBytes;external 'USB2XXX.dll' name 'IIC_WriteReadBytes';

function IIC_SlaveWriteBytes;external 'USB2XXX.dll' name 'IIC_SlaveWriteBytes';
function IIC_SlaveReadBytes;external 'USB2XXX.dll' name 'IIC_SlaveReadBytes';
function IIC_SlaveWriteRemain;external 'USB2XXX.dll' name 'IIC_SlaveWriteRemain';

function IIC_WriteBytesOfEvent;external 'USB2XXX.dll' name 'IIC_WriteBytesOfEvent';
function IIC_ReadBytesOfEvent;external 'USB2XXX.dll' name 'IIC_ReadBytesOfEvent';
function IIC_WriteReadBytesOfEvent;external 'USB2XXX.dll' name 'IIC_WriteReadBytesOfEvent';

function SMBUS_Init;external 'USB2XXX.dll' name 'SMBUS_Init';
function SMBUS_QuickCommand;external 'USB2XXX.dll' name 'SMBUS_QuickCommand';
function SMBUS_WriteByte;external 'USB2XXX.dll' name 'SMBUS_WriteByte';
function SMBUS_ReadByte;external 'USB2XXX.dll' name 'SMBUS_ReadByte';
function SMBUS_WriteByteProtocol;external 'USB2XXX.dll' name 'SMBUS_WriteByteProtocol';
function SMBUS_WriteWordProtocol;external 'USB2XXX.dll' name 'SMBUS_WriteWordProtocol';
function SMBUS_ReadByteProtocol;external 'USB2XXX.dll' name 'SMBUS_ReadByteProtocol';
function SMBUS_ReadWordProtocol;external 'USB2XXX.dll' name 'SMBUS_ReadWordProtocol';
function SMBUS_ProcessCall;external 'USB2XXX.dll' name 'SMBUS_ProcessCall';
function SMBUS_BlockWrite;external 'USB2XXX.dll' name 'SMBUS_BlockWrite';
function SMBUS_BlockRead;external 'USB2XXX.dll' name 'SMBUS_BlockRead';
function SMBUS_BlockProcessCall;external 'USB2XXX.dll' name 'SMBUS_BlockProcessCall';
end.

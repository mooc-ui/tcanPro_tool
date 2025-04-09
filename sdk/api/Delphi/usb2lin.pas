unit usb2lin;

interface

const
//���庯�����ش������
LIN_SUCCESS             = (0);   //����ִ�гɹ�
LIN_ERR_NOT_SUPPORT     = (-1);  //��������֧�ָú���
LIN_ERR_USB_WRITE_FAIL  = (-2);  //USBд����ʧ��
LIN_ERR_USB_READ_FAIL   = (-3);  //USB������ʧ��
LIN_ERR_CMD_FAIL        = (-4);  //����ִ��ʧ��
LIN_ERR_CH_NO_INIT      = (-5);  //��ͨ��δ��ʼ��
LIN_ERR_READ_DATA       = (-6);  //LIN������ʧ��
//LIN��У��ģʽ
LIN_CHECK_MODE_STD     = 0;
LIN_CHECK_MODE_EXT     = 1;
LIN_CHECK_MODE_NONE    = 2;
//�ӻ�ģʽ�¼��BREAK�ź�λ������
LIN_BREAK_BITS_10    = $00;
LIN_BREAK_BITS_11    = $20;
//��������ģʽ
LIN_MASTER          = 1;
LIN_SLAVE           = 0;
//����ӻ�����ģʽ
LIN_SLAVE_WRITE     = 0;
LIN_SLAVE_READ      = 1;

//�����ʼ��LIN��ʼ����������
type
PLIN_CONFIG = ^LIN_CONFIG;
LIN_CONFIG = record
  BaudRate:LongWord;      //������,���20K
  CheckMode:Byte;         //У��ģʽ��0-��׼У��ģʽ��1-��ǿУ��ģʽ������PID��
  MasterMode:Byte;        //����ģʽ��0-��ģʽ��1-��ģʽ
  BreakBits:Byte;         //Break���ȣ�0x00-10bit,0x20-11bit
end;
//LIN�����շ�֡��ʽ����
type
PLIN_MSG = ^LIN_MSG;
LIN_MSG = record
  ID:Byte;                  //ID��ȡֵ��Χ0~0x3F
  DataLen:Byte;             //��������ʱ�����������ݵĳ��ȣ�����У�����ݣ���������ʱ�����ݵĳ��ȣ�����У������
  Data:Array[0..8] Of Byte; //���ݴ洢��
end;
//��������
function LIN_Init(DevHandle:LongWord; LINIndex:Byte;pConfig:PLIN_CONFIG):Integer; stdcall;
function LIN_Write(DevHandle:LongWord; LINIndex:Byte;pLINMsg:PLIN_MSG;Len:LongWord):Integer; stdcall;
function LIN_Read(DevHandle:LongWord; LINIndex:Byte;pLINMsg:PLIN_MSG;Len:LongWord):Integer; stdcall;
function LIN_SlaveSetIDMode(DevHandle:LongWord; LINIndex,IDMode:Byte;pLINMsg:PLIN_MSG;Len:LongWord):Integer; stdcall;
function LIN_SlaveGetData(DevHandle:LongWord; LINIndex:Byte;pLINMsg:PLIN_MSG):Integer; stdcall;

implementation
function LIN_Init;external 'USB2XXX.dll' name 'LIN_Init';
function LIN_Write;external 'USB2XXX.dll' name 'LIN_Write';
function LIN_Read;external 'USB2XXX.dll' name 'LIN_Read';
function LIN_SlaveSetIDMode;external 'USB2XXX.dll' name 'LIN_SlaveSetIDMode';
function LIN_SlaveGetData;external 'USB2XXX.dll' name 'LIN_SlaveGetData';
end.

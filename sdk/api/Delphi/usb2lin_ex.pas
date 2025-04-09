unit usb2lin_ex;

interface

const
//���庯�����ش������
LIN_EX_SUCCESS            = (0);   //����ִ�гɹ�
LIN_EX_ERR_NOT_SUPPORT    = (-1);  //��������֧�ָú���
LIN_EX_ERR_USB_WRITE_FAIL = (-2);  //USBд����ʧ��
LIN_EX_ERR_USB_READ_FAIL  = (-3);  //USB������ʧ��
LIN_EX_ERR_CMD_FAIL       = (-4);  //����ִ��ʧ��
LIN_EX_ERR_CH_NO_INIT     = (-5);  //��ͨ��δ��ʼ��
LIN_EX_ERR_READ_DATA      = (-6);  //LIN������ʧ��
LIN_EX_ERR_PARAMETER      = (-7);  //����������������
//У������
LIN_EX_CHECK_STD    = 0;  //��׼У�飬����PID
LIN_EX_CHECK_EXT    = 1;  //��ǿУ�飬����PID
LIN_EX_CHECK_USER   = 2;  //�Զ���У�����ͣ���Ҫ�û��Լ����㲢����Check���������Զ�У��
LIN_EX_CHECK_NONE   = 3;  //������У������
LIN_EX_CHECK_ERROR  = 4;  //��������У�����
//���ӻ�����
LIN_EX_MASTER       = 1;  //����
LIN_EX_SLAVE        = 0;  //�ӻ�
//֡����
LIN_EX_MSG_TYPE_UN     = 0;  //δ֪����
LIN_EX_MSG_TYPE_MW     = 1;  //������ӻ���������
LIN_EX_MSG_TYPE_MR     = 2;  //�����Ӵӻ���ȡ����
LIN_EX_MSG_TYPE_SW     = 3;  //�ӻ���������
LIN_EX_MSG_TYPE_SR     = 4;  //�ӻ���������
LIN_EX_MSG_TYPE_BK     = 5;  //ֻ����BREAK�źţ����Ƿ������������ݣ�����ֻ��⵽BREAK�ź�
LIN_EX_MSG_TYPE_SY     = 6;  //������⵽��BREAK��SYNC�ź�
LIN_EX_MSG_TYPE_ID     = 7;  //������⵽��BREAK��SYNC��PID�ź�
LIN_EX_MSG_TYPE_DT     = 8;  //������⵽��BREAK��SYNC��PID,DATA�ź�
LIN_EX_MSG_TYPE_CK     = 9;  //������⵽��BREAK��SYNC��PID,DATA,CHECK�ź�

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
PLIN_EX_MSG = ^LIN_EX_MSG;
LIN_EX_MSG = record
    Timestamp:LongWord;    //�ӻ���������ʱ����ʱ�������λΪ0.1ms;������д����ʱ����ʾ���ݶ�д�����ʱʱ�䣬��λΪms
    MsgType:Byte;      //֡����
    CheckType:Byte;    //У������
    DataLen:Byte;      //LIN���ݶ���Ч�����ֽ���
    Sync:Byte;         //�̶�ֵ��0x55
    PID:Byte;          //֡ID
    Data:Array[0..7] Of Byte;      //����
    Check:Byte;        //У��,ֻ��У����������ΪLIN_EX_CHECK_USER��ʱ�����Ҫ�û���������
    BreakBits:Byte;    //��֡��BRAK�ź�λ������ЧֵΪ10��26��������Ϊ����ֵ��Ĭ��Ϊ13λ
    Reserve1:Byte;
end;

//��ʼ��
function LIN_EX_Init(DevHandle:LongWord;LINIndex:Byte;BaudRate:LongWord;MasterMode:Byte):Integer; stdcall;
//����ģʽ��������
function LIN_EX_MasterSync(DevHandle:LongWord;LINIndex:Byte;pInMsg,pOutMsg:PLIN_EX_MSG;MsgLen:LongWord):Integer; stdcall;
function LIN_EX_MasterWrite(DevHandle:LongWord;LINIndex,PID:Byte;pData:PByte;DataLen,CheckType:Byte):Integer; stdcall;
function LIN_EX_MasterRead(DevHandle:LongWord;LINIndex,PID:Byte;pData:PByte):Integer; stdcall;
//�ӻ�ģʽ��������
function LIN_EX_SlaveSetIDMode(DevHandle:LongWord;LINIndex:Byte;pLINMsg:PLIN_EX_MSG;MsgLen:LongWord):Integer; stdcall;
function LIN_EX_SlaveGetIDMode(DevHandle:LongWord;LINIndex:Byte;pLINMsg:PLIN_EX_MSG):Integer; stdcall;
function LIN_EX_SlaveGetData(DevHandle:LongWord;LINIndex:Byte;pLINMsg:PLIN_EX_MSG):Integer; stdcall;
//��Դ������غ���
function LIN_EX_CtrlPowerOut(DevHandle:LongWord;State:Byte):Integer; stdcall;
function LIN_EX_GetVbatValue(DevHandle:LongWord;pBatValue:PWord):Integer; stdcall;
//����ģʽ�Զ�����������غ���
function LIN_EX_MasterStartSch(DevHandle:LongWord;LINIndex:Byte;pLINMsg:PLIN_EX_MSG;MsgLen:LongWord):Integer; stdcall;
function LIN_EX_MasterStopSch(DevHandle:LongWord;LINIndex:Byte):Integer; stdcall;
function LIN_EX_MasterGetSch(DevHandle:LongWord;LINIndex:Byte;pLINMsg:PLIN_EX_MSG):Integer; stdcall;

implementation
function LIN_EX_Init;external 'USB2XXX.dll' name 'LIN_EX_Init';
function LIN_EX_MasterSync;external 'USB2XXX.dll' name 'LIN_EX_MasterSync';
function LIN_EX_MasterWrite;external 'USB2XXX.dll' name 'LIN_EX_MasterWrite';
function LIN_EX_MasterRead;external 'USB2XXX.dll' name 'LIN_EX_MasterRead';
function LIN_EX_SlaveSetIDMode;external 'USB2XXX.dll' name 'LIN_EX_SlaveSetIDMode';
function LIN_EX_SlaveGetIDMode;external 'USB2XXX.dll' name 'LIN_EX_SlaveGetIDMode';
function LIN_EX_SlaveGetData;external 'USB2XXX.dll' name 'LIN_EX_SlaveGetData';
function LIN_EX_CtrlPowerOut;external 'USB2XXX.dll' name 'LIN_EX_CtrlPowerOut';
function LIN_EX_GetVbatValue;external 'USB2XXX.dll' name 'LIN_EX_GetVbatValue';
function LIN_EX_MasterStartSch;external 'USB2XXX.dll' name 'LIN_EX_MasterStartSch';
function LIN_EX_MasterStopSch;external 'USB2XXX.dll' name 'LIN_EX_MasterStopSch';
function LIN_EX_MasterGetSch;external 'USB2XXX.dll' name 'LIN_EX_MasterGetSch';
end.

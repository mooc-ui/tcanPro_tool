Attribute VB_Name = "usb2canfd"

Public Type CANFD_MSG
    ID As Long
    DLC As 
    Flags As Byte
    __Res0 As Byte
    TimeStampHigh As Byte
    TimeStamp As Long
    Data(63) As Byte
End Type

Public Type CANFD_INIT_CONFIG
    Mode As Byte
    ISOCRCEnable As Byte
    RetrySend As Byte
    ResEnable As Byte
    NBT_BRP As Byte
    NBT_SEG1 As Byte
    NBT_SEG2 As Byte
    NBT_SJW As Byte
    DBT_BRP As Byte
    DBT_SEG1 As Byte
    DBT_SEG2 As Byte
    DBT_SJW As Byte
    __Res0(7) As Byte
End Type

Public Type CANFD_FILTER_CONFIG
    Enable As Byte
    Index As Byte
    __Res0 As Byte
    __Res1 As Byte
    ID_Accept As Long
    ID_Mask As Long
End Type

Public Type CANFD_BUS_ERROR
    TEC As Byte
    REC As Byte
    Flags As Byte
    __Res0 As Byte
End Type

Public Type CANFD_DIAGNOSTIC
    NREC As Byte
    NTEC As Byte
    DREC As Byte
    DTEC As Byte
    ErrorFreeMsgCount As Integer
    Flags As Integer
End Type

'��������ֵ������Ϣ����
Public Const CANFD_SUCCESS As Long = (0)   '����ִ�гɹ�
Public Const CANFD_ERR_NOT_SUPPORT As Long = (-1)  '��������֧�ָú���
Public Const CANFD_ERR_USB_WRITE_FAIL As Long = (-2)  'USBд����ʧ��
Public Const CANFD_ERR_USB_READ_FAIL As Long = (-3)  'USB������ʧ��
Public Const CANFD_ERR_CMD_FAIL As Long = (-4)  '����ִ��ʧ��
'CANFD_MSG.ID����
Public Const CANFD_MSG_FLAG_RTR As Long = (&H40000000)
Public Const CANFD_MSG_FLAG_IDE As Long = (&H80000000)
Public Const CANFD_MSG_FLAG_ID_MASK As Long = (&H1FFFFFFF)
'CANFD_MSG.Flags����
Public Const CANFD_MSG_FLAG_BRS As Byte = (&H01)  'CANFD����֡��־
Public Const CANFD_MSG_FLAG_ESI As Byte = (&H02)
Public Const CANFD_MSG_FLAG_FDF As Byte = (&H04)  'CANFD֡��־
Public Const CANFD_MSG_FLAG_TXD As Byte = (&H80)
'CANFD_DIAGNOSTIC.Flags����
Public Const CANFD_DIAGNOSTIC_FLAG_NBIT0_ERR     (&H0001)'�ڷ��ͱ��ģ���Ӧ��λ�����������־����ر�־���ڼ䣬����Ҫ�������Ե�ƽ���߼�ֵΪ0�����ݻ��ʶ��λ���������ӵ�����ֵΪ���ԡ�
Public Const CANFD_DIAGNOSTIC_FLAG_NBIT1_ERR As Long = (&H0002)'�ڷ��ͱ��ģ��ٲ��ֶγ��⣩�ڼ䣬����Ҫ�������Ե�ƽ���߼�ֵΪ1��λ���������ӵ�������ֵΪ���ԡ�
Public Const CANFD_DIAGNOSTIC_FLAG_NACK_ERR As Long = (&H0004)'���ͱ���δӦ��
Public Const CANFD_DIAGNOSTIC_FLAG_NFORM_ERR As Long = (&H0008)'���ձ��ĵĹ̶���ʽ���ָ�ʽ����
Public Const CANFD_DIAGNOSTIC_FLAG_NSTUFF_ERR  As Long = (&H0010)'�ڽ��ձ��ĵ�һ�����У������а�����5���������λ���������в���������������С�
Public Const CANFD_DIAGNOSTIC_FLAG_NCRC_ERR As Long = (&H0020)'���յı��ĵ�CRCУ��Ͳ���ȷ�����뱨�ĵ�CRC��ͨ�����յ������ݼ���õ���CRC��ƥ�䡣
Public Const CANFD_DIAGNOSTIC_FLAG_TXBO_ERR As Long = (&H0080)'������������״̬�����Զ��ָ�����
Public Const CANFD_DIAGNOSTIC_FLAG_DBIT0_ERR As Long = (&H0100)'��NBIT0_ERR
Public Const CANFD_DIAGNOSTIC_FLAG_DBIT1_ERR As Long = (&H0200)'��NBIT1_ERR
Public Const CANFD_DIAGNOSTIC_FLAG_DFORM_ERR As Long = (&H0800)'��NFORM_ERR
Public Const CANFD_DIAGNOSTIC_FLAG_DSTUFF_ERR As Long = (&H1000)'��NSTUFF_ERR
Public Const CANFD_DIAGNOSTIC_FLAG_DCRC_ERR As Long = (&H2000)'��NCRC_ERR
Public Const CANFD_DIAGNOSTIC_FLAG_ESI_ERR As Long = (&H4000)'���յ�CAN FD���ĵ�ESI��־��1
Public Const CANFD_DIAGNOSTIC_FLAG_DLC_MISMATCH As Long = (&H8000)'DLC��ƥ��,�ڷ��ͻ�����ڼ䣬ָ����DLC����FIFOԪ�ص�PLSIZE
'CANFD_BUS_ERROR.Flags����
Public Const CANFD_BUS_ERROR_FLAG_TX_RX_WARNING As Byte = (&H01)
Public Const CANFD_BUS_ERROR_FLAG_RX_WARNING As Byte = (&H02)
Public Const CANFD_BUS_ERROR_FLAG_TX_WARNING As Byte = (&H04)
Public Const CANFD_BUS_ERROR_FLAG_RX_BUS_PASSIVE As Byte = (&H08)
Public Const CANFD_BUS_ERROR_FLAG_TX_BUS_PASSIVE As Byte = (&H10)
Public Const CANFD_BUS_ERROR_FLAG_TX_BUS_OFF As Byte = (&H20)

Declare Function CANFD_GetCANSpeedArg Lib "USB2XXX.dll" (ByVal DevHandle As Long, ByRef pCanConfig As CANFD_INIT_CONFIG, ByVal SpeedBpsNBT As Long, ByVal SpeedBpsDBT As Long) As Long
Declare Function CANFD_Init Lib "USB2XXX.dll" (ByVal DevHandle As Long, ByVal CANIndex As Byte, ByRef pCanConfig As CANFD_INIT_CONFIG) As Long
Declare Function CANFD_StartGetMsg Lib "USB2XXX.dll" (ByVal DevHandle As Long, ByVal CANIndex As Byte) As Long
Declare Function CANFD_StopGetMsg Lib "USB2XXX.dll" (ByVal DevHandle As Long, ByVal CANIndex As Byte) As Long
Declare Function CANFD_SendMsg Lib "USB2XXX.dll" (ByVal DevHandle As Long, ByVal CANIndex As Byte, ByVal pCanSendMsg As Long,unsigned ByVal SendMsgNum As Long) As Long
Declare Function CANFD_GetMsg Lib "USB2XXX.dll" (ByVal DevHandle As Long, ByVal CANIndex As Byte, ByVal pCanGetMsg As Long,ByVal BufferSize As Long) As Long
Declare Function CANFD_ClearMsg Lib "USB2XXX.dll" (ByVal DevHandle As Long, ByVal CANIndex As Byte) As Long
Declare Function CANFD_SetFilter Lib "USB2XXX.dll" (ByVal DevHandle As Long, ByVal CANIndex As Byte, ByRef pCanFilter As CANFD_FILTER_CONFIG,ByVal Len As Byte) As Long
Declare Function CANFD_GetDiagnostic Lib "USB2XXX.dll" (ByVal DevHandle As Long, ByVal CANIndex As Byte, ByRef pCanDiagnostic As CANFD_DIAGNOSTIC) As Long
Declare Function CANFD_GetBusError Lib "USB2XXX.dll" (ByVal DevHandle As Long, ByVal CANIndex As Byte, ByRef pCanBusError As CANFD_BUS_ERROR) As Long
Declare Function CANFD_SetSchedule Lib "USB2XXX.dll" (ByVal DevHandle As Long, ByVal CANIndex As Byte, ByVal pCanMsgTab As Long,ByVal pMsgNum  As Long,ByVal pSendTimes As Long,ByVal MsgTabNum As Byte) As Long
Declare Function CANFD_StartSchedule Lib "USB2XXX.dll" (ByVal DevHandle As Long, ByVal CANIndex As Byte, ByVal MsgTabIndex As Byte,ByVal TimePrecMs As Byte,ByVal OrderSend As Byte) As Long
Declare Function CANFD_StopSchedule Lib "USB2XXX.dll" (ByVal DevHandle As Long, ByVal CANIndex As Byte) As Long



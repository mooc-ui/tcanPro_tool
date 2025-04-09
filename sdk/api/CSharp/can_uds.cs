﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

namespace USB2XXX
{
    class CAN_UDS
    {
        //CAN UDS地址定义
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]  
        public struct CAN_UDS_ADDR
        {
            public UInt32  ReqID;       //请求报文ID。
            public UInt32  ResID;       //应答报文ID。
            public Byte    Flag;        //bit[0]-帧类型(0-标准帧，1-扩展帧),bit[1]-FDF(0-普通CAN帧，1-CANFD帧),bit[2]-BRS(0-CANFD帧不加速，1-CANFD帧加速)
            public Byte    AddrFormats; //0-normal, 1-extended ,2-mixed
            public Byte    AddrExt;     //当AddrFormats不为normal时，该数据放到CAN数据域第1字节
            public Byte    MaxDLC;      //普通CAN设置为8，CANFD帧可以最大设置为64
        };

        //函数返回错误代码定义
        public const Int32 CAN_UDS_OK            = 0;
        public const Int32 CAN_UDS_TRAN_USB      = -98;
        public const Int32 CAN_UDS_TRAN_CAN      = -99;
        public const Int32 CAN_UDS_TIMEOUT_A     = -100;
        public const Int32 CAN_UDS_TIMEOUT_Bs    = -101;
        public const Int32 CAN_UDS_TIMEOUT_Cr    = -102;
        public const Int32 CAN_UDS_WRONG_SN      = -103;
        public const Int32 CAN_UDS_INVALID_FS    = -104;
        public const Int32 CAN_UDS_UNEXP_PDU     = -105;
        public const Int32 CAN_UDS_WFT_OVRN      = -106;
        public const Int32 CAN_UDS_BUFFER_OVFLW  = -107;
        public const Int32 CAN_UDS_ERROR = -108;

        //USB2CAN相关函数定义
        [DllImport("USB2XXX.dll")]
        public static extern Int32 CAN_UDS_Request(Int32 DevHandle, Byte CANIndex, ref CAN_UDS_ADDR UDSAddr, Byte[] pReqData, Int32 DataLen);
        [DllImport("USB2XXX.dll")]
        public static extern Int32 CAN_UDS_Response(Int32 DevHandle, Byte CANIndex, ref CAN_UDS_ADDR UDSAddr, Byte[] pResData, Int32 TimeOutMs);
    }
}

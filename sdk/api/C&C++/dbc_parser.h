/*******************************************************************************
  * @file    dbc_parser.h
  * $Author: wdluo $
  * $Revision: 447 $
  * $Date:: 2022-03-30 18:24:57 +0800 #$
  * @brief   DBC�ļ�������غ������������Ͷ���.
  ******************************************************************************
  * @attention
  *
  *<center><a href="http:\\www.toomoss.com">http://www.toomoss.com</a></center>
  *<center>All Rights Reserved</center></h3>
  *
  ******************************************************************************
  */
#ifndef __DBC_PARSER_H_
#define __DBC_PARSER_H_

#include <stdint.h>
#ifndef OS_UNIX
#include <Windows.h>
#else
#include <unistd.h>
#ifndef WINAPI
#define WINAPI
#endif
#endif

#define DBC_PARSER_OK                   0//û�д���
#define DBC_PARSER_FILE_OPEN         (-1)//���ļ�����
#define DBC_PARSER_FILE_FORMAT       (-2)//�ļ���ʽ����
#define DBC_PARSER_DEV_DISCONNECT    (-3)//�豸δ����
#define DBC_PARSER_HANDLE_ERROR      (-4)//DBC Handle����
#define DBC_PARSER_GET_INFO_ERROR    (-5)//��ȡ����������ݳ���
#define DBC_PARSER_DATA_ERROR        (-6)//���ݴ������
#define DBC_PARSER_SLAVE_NACK        (-7)//�ӻ�δ��Ӧ����

#ifdef __cplusplus
extern "C"
{
#endif
    long long WINAPI DBC_ParserFile(int DevHandle, char* pDBCFileName);
    int WINAPI DBC_GetMsgQuantity(long long DBCHandle);
    int WINAPI DBC_GetMsgName(long long DBCHandle, int index, char* pMsgName);
    int WINAPI DBC_GetMsgSignalQuantity(long long DBCHandle, char* pMsgName);
    int WINAPI DBC_GetMsgSignalName(long long DBCHandle, char* pMsgName, int index, char* pSignalName);
    int WINAPI DBC_GetMsgPublisher(long long DBCHandle, char* pMsgName, char* pPublisher);
    //�����ź�ֵ
    int WINAPI DBC_SetSignalValue(long long DBCHandle, char* pMsgName, char* pSignalName, double Value);
    //��ȡ�ź�ֵ
    int WINAPI DBC_GetSignalValue(long long DBCHandle, char* pMsgName, char* pSignalName, double* pValue);
    int WINAPI DBC_GetSignalValueStr(long long DBCHandle, char* pMsgName, char* pSignalName, char* pValueStr);
    //��CAN��Ϣ������䵽�ź�����
    int WINAPI DBC_SyncCANMsgToValue(long long DBCHandle, void* pCANMsg,int MsgLen);
    int WINAPI DBC_SyncCANFDMsgToValue(long long DBCHandle, void* pCANFDMsg, int MsgLen);
    //���ź�������䵽CAN��Ϣ����
    int WINAPI DBC_SyncValueToCANMsg(long long DBCHandle, char* pMsgName, void* pCANMsg);
    int WINAPI DBC_SyncValueToCANFDMsg(long long DBCHandle, char* pMsgName, void* pCANFDMsg);
#ifdef __cplusplus
}
#endif

#endif



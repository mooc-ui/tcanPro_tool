/*******************************************************************************
  * @file    ldf_parser.h
  * $Author: wdluo $
  * $Revision: 447 $
  * $Date:: 2013-06-29 18:24:57 +0800 #$
  * @brief   LDF�ļ�������غ������������Ͷ���.
  ******************************************************************************
  * @attention
  *
  *<center><a href="http:\\www.toomoss.com">http://www.toomoss.com</a></center>
  *<center>All Rights Reserved</center></h3>
  * 
  ******************************************************************************
  */
#ifndef __LDF_PARSER_H_
#define __LDF_PARSER_H_

#include <stdint.h>
#ifndef OS_UNIX
#include <Windows.h>
#else
#include <unistd.h>
#ifndef WINAPI
#define WINAPI
#endif
#endif

#define LDF_PARSER_OK                   0//û�д���
#define LDF_PARSER_FILE_OPEN         (-1)//���ļ�����
#define LDF_PARSER_FILE_FORMAT       (-2)//�ļ���ʽ����
#define LDF_PARSER_DEV_DISCONNECT    (-3)//�豸δ����
#define LDF_PARSER_HANDLE_ERROR      (-4)//LDF Handle����
#define LDF_PARSER_GET_INFO_ERROR    (-5)//��ȡ����������ݳ���
#define LDF_PARSER_DATA_ERROR        (-6)//���ݴ������
#define LDF_PARSER_SLAVE_NACK        (-7)//�ӻ�δ��Ӧ����

#ifdef __cplusplus
extern "C"
{
#endif
    long long WINAPI LDF_ParserFile(int DevHandle, int LINIndex, unsigned char isMaster, char* pLDFFileName);
    int WINAPI LDF_GetProtocolVersion(long long LDFHandle);
    int WINAPI LDF_GetLINSpeed(long long LDFHandle);
    int WINAPI LDF_GetFrameQuantity(long long LDFHandle);
    int WINAPI LDF_GetFrameName(long long LDFHandle, int index, char* pFrameName);
    int WINAPI LDF_GetFrameSignalQuantity(long long LDFHandle, char* pFrameName);
    int WINAPI LDF_GetFrameSignalName(long long LDFHandle, char* pFrameName, int index, char* pSignalName);
    int WINAPI LDF_SetSignalValue(long long LDFHandle, char* pFrameName, char* pSignalName, double Value);
    int WINAPI LDF_GetSignalValue(long long LDFHandle, char* pFrameName, char* pSignalName, double *pValue);
    int WINAPI LDF_GetSignalValueStr(long long LDFHandle, char* pFrameName, char* pSignalName, char* pValueStr);
    //int WINAPI LDF_SetFrameRawValue(long long LDFHandle, unsigned char ID, unsigned char* pRawData);
    int WINAPI LDF_SetFrameRawValue(long long LDFHandle, char* pFrameName, unsigned char* pRawData);
    //int WINAPI LDF_GetFrameRawValue(long long LDFHandle, unsigned char ID, unsigned char* pRawData);
    int WINAPI LDF_GetFrameRawValue(long long LDFHandle, char* pFrameName, unsigned char* pRawData);
    int WINAPI LDF_GetFramePublisher(long long LDFHandle, char* pFrameName, char* pPublisher);
    int WINAPI LDF_GetMasterName(long long LDFHandle,  char* pMasterName);
    int WINAPI LDF_GetSchQuantity(long long LDFHandle);
    int WINAPI LDF_GetSchName(long long LDFHandle, int index, char* pSchName);
    int WINAPI LDF_GetSchFrameQuantity(long long LDFHandle, char* pSchName);
    int WINAPI LDF_GetSchFrameName(long long LDFHandle, char* pSchName, int index, char* pFrameName);
    int WINAPI LDF_ExeFrameToBus(long long LDFHandle, char* pFrameName, unsigned char FillBitValue);
    int WINAPI LDF_ExeSchToBus(long long LDFHandle, char* pSchName, unsigned char FillBitValue);

#ifdef __cplusplus
}
#endif

#endif



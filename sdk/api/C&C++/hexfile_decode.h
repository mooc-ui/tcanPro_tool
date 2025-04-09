/**
  ******************************************************************************
  * @file    hexfile_decode.h
  * $Author: wdluo $
  * $Revision: 447 $
  * $Date:: 2013-06-29 18:24:57 +0800 #$
  * @brief   HEX,S19�ļ�������غ������������Ͷ���.
  ******************************************************************************
  * @attention
  *
  *<center><a href="http:\\www.toomoss.com">http://www.toomoss.com</a></center>
  *<center>All Rights Reserved</center></h3>
  * 
  ******************************************************************************
  */
#ifndef __HEXFILE_DECODE_H_
#define __HEXFILE_DECODE_H_

#include <stdint.h>
#ifndef OS_UNIX
#include <Windows.h>
#else
#include <unistd.h>
#ifndef WINAPI
#define WINAPI
#endif
#endif

//�ļ����ݿ鶨��
typedef struct _HEX_FILE_BLOCK
{
    unsigned int  StartAddr;//���ݿ���ʼ��ַ
    unsigned int  DataNum;  //���ݿ��ֽ���
    unsigned char *pData;   //���ݿ����ݴ洢ָ��
}HEX_FILE_BLOCK,*PHEX_FILE_BLOCK;

//�洢������
#define MEMTYPE_UINT8    1  //1����ַ��Ԫ�洢1�ֽ�����
#define MEMTYPE_UINT16   2  //1����ַ��Ԫ�洢2�ֽ�����
#define MEMTYPE_UINT32   4  //1����ַ��Ԫ�洢4�ֽ�����

#ifdef __cplusplus
extern "C"
{
#endif
    int WINAPI hexfile_load_file(const char *filename, char *fileBuf);
    int WINAPI hexfile_convert_s19(char *fileBuf, int lenFileBuf, HEX_FILE_BLOCK *pHexFileBlock, int maxBlockNum, char memType);
    int WINAPI hexfile_convert_ihx(char *fileBuf, int lenFileBuf, HEX_FILE_BLOCK *pHexFileBlock, int maxBlockNum, char memType);
    int WINAPI hexfile_convert_txt(char *fileBuf, int lenFileBuf, HEX_FILE_BLOCK *pHexFileBlock, int maxBlockNum, char memType);
    int WINAPI hexfile_free_data(HEX_FILE_BLOCK *pHexFileBlock, int maxBlockNum);
    int WINAPI hexfile_save_image(const char *filename,HEX_FILE_BLOCK *pHexFileBlock, int maxBlockNum, char memType,char fillBytes);
    int WINAPI hexfile_convert_image(char *pOutData,HEX_FILE_BLOCK *pHexFileBlock, int maxBlockNum, char memType,char fillBytes);
#ifdef __cplusplus
}
#endif

#endif

/**
  ******************************************************************************
  * @file    usb2sent.h
  * $Author: wdluo $
  * $Revision: 447 $
  * $Date:: 2013-06-29 18:24:57 +0800 #$
  * @brief   usb2sent��غ������������Ͷ���.
  ******************************************************************************
  * @attention
  *
  *<center><a href="http:\\www.toomoss.com">http://www.toomoss.com</a></center>
  *<center>All Rights Reserved</center></h3>
  * 
  ******************************************************************************
  */
#ifndef __USB2SENT_H_
#define __USB2SENT_H_

#include <stdint.h>
#ifndef OS_UNIX
#include <Windows.h>
#else
#include <unistd.h>
#ifndef WINAPI
#define WINAPI
#endif
#endif
//���庯�����ش������
#define SENT_SUCCESS             (0)   //����ִ�гɹ�
#define SENT_ERR_NOT_SUPPORT     (-1)  //��������֧�ָú���
#define SENT_ERR_USB_WRITE_FAIL  (-2)  //USBд����ʧ��
#define SENT_ERR_USB_READ_FAIL   (-3)  //USB������ʧ��
#define SENT_ERR_CMD_FAIL        (-4)  //����ִ��ʧ��
#define SENT_ERR_PARAMETER       (-7)  //����������������

#ifdef __cplusplus
extern "C"
{
#endif
//��ʼ��
int WINAPI  SENT_Init(int DevHandle,unsigned char Channel,unsigned char TicksTimeUs,unsigned char MasterMode);
int WINAPI  SENT_SendData(int DevHandle,unsigned char Channel,unsigned char Status,unsigned char SendPause,unsigned char *pHalfByteData,unsigned char DataNum);
#ifdef __cplusplus
}
#endif

#endif

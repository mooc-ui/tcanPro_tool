/**
  ******************************************************************************
  * @file    elmos_programer.h
  * $Author: wdluo $
  * $Revision: 447 $
  * $Date:: 2013-06-29 18:24:57 +0800 #$
  * @brief   elmos_programer��غ������������Ͷ���.
  ******************************************************************************
  * @attention
  *
  *<center><a href="http:\\www.toomoss.com">http://www.toomoss.com</a></center>
  *<center>All Rights Reserved</center></h3>
  * 
  ******************************************************************************
  */
#ifndef __ELMOS_PROGRAMER_H_
#define __ELMOS_PROGRAMER_H_

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
#define ELMOS_SUCCESS             (0)     //����ִ�гɹ�
#define ELMOS_ERR_OPEN_DEV        (-1)    //���豸ʧ��
#define ELMOS_ERR_INIT_DEV        (-2)    //��ʼ���豸ʧ��
#define ELMOS_ERR_FILE_FORMAT     (-3)    //�ļ���ʽ����
#define ELMOS_ERR_BEGIN_PROG      (-4)    //������ģʽ����
#define ELMOS_ERR_CMD_FAIL        (-5)    //����ִ��ʧ��
#define ELMOS_ERR_PRG_FAILD       (-6)    //���ʧ��
#define ELMOS_ERR_FIND_CHIP       (-7)    //Ѱ��оƬʧ��

#ifdef __cplusplus
extern "C"
{
#endif

    int WINAPI ELMOS_StartProg(int DeviceHandle, unsigned char LINChannel,const char* AppFileName);

#ifdef __cplusplus
}
#endif


#endif


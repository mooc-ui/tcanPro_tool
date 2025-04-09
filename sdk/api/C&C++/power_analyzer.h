/**
  ******************************************************************************
  * @file    power_analyzer.h
  * $Author: wdluo $
  * $Revision: 447 $
  * $Date:: 2021-03-31 18:24:57 +0800 #$
  * @brief   ���ķ�������غ������������Ͷ���.
  ******************************************************************************
  * @attention
  *
  *<center><a href="http:\\www.toomoss.com">http://www.toomoss.com</a></center>
  *<center>All Rights Reserved</center></h3>
  * 
  ******************************************************************************
  */
#ifndef __POWER_ANALYZER_H_
#define __POWER_ANALYZER_H_

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
#define PA_SUCCESS             (0)   //����ִ�гɹ�
#define PA_ERR_NOT_SUPPORT     (-1)  //��������֧�ָú���
#define PA_ERR_USB_WRITE_FAIL  (-2)  //USBд����ʧ��
#define PA_ERR_USB_READ_FAIL   (-3)  //USB������ʧ��
#define PA_ERR_CMD_FAIL        (-4)  //����ִ��ʧ��



#ifdef __cplusplus
extern "C"
{
#endif
/**
  * @brief  ���ķ����ǳ�ʼ������
  * @param  DevHandle �豸������
  * @param  Channel ��ѹ�����ɼ�ͨ���ţ�����0����
  * @param  SamplingRate ��ѹ���������ʣ�ȡֵ��ΧΪ1~500000
  * @param  AutoZeroSet �������ã�0-�����㣬1-��ʼ����ʱ����Զ����㣬�Զ�������Ҫ���������Դ���Ͽ������Դ����Դ������ӣ���ֻ��Ե������ݵ���
  * @param  UseZeroSet ʹ�õ��������0-��ʹ�õ�����������������ݻ���һ���̶���ƫ������1-ʹ�õ�������������������Ǽ�ȥ��������������
  * @param  FilterLevel �˲�����ȡֵ��ΧΪ0��2000����ֵԽ������Խƽ����0��ʾ���˲�
  * @retval ����ִ��״̬��С��0����ִ�г���
  */
int WINAPI  PA_Init(int DevHandle,int Channel,int SamplingRate,unsigned char AutoZeroSet,unsigned char UseZeroSet,int FilterLevel);
/**
  * @brief  ��ʼ�ɼ�����
  * @param  DevHandle �豸������
  * @param  Channel ��ѹ�����ɼ�ͨ���ţ�����0����
  * @retval ����ִ��״̬��С��0����ִ�г���
  */
int WINAPI  PA_StartGetData(int DevHandle,int Channel);
/**
  * @brief  ֹͣ�ɼ�����
  * @param  DevHandle �豸������
  * @param  Channel ��ѹ�����ɼ�ͨ���ţ�����0����
  * @retval ����ִ��״̬��С��0����ִ�г���
  */
int WINAPI  PA_StopGetData(int DevHandle,int Channel);
/**
  * @brief  ��ȡ��ѹ����
  * @param  DevHandle �豸������
  * @param  Channel ��ѹ�����ɼ�ͨ���ţ�����0����
  * @param  pVoltage ��ѹֵ�洢�������׵�ַ����λΪV
  * @param  BufferSize ���ݻ���������
  * @retval ʵ�ʻ�ȡ�������ݸ�����С��0����ִ�г���
  */
int WINAPI  PA_GetVoltageData(int DevHandle,int Channel,double *pVoltage,int BufferSize);
/**
  * @brief  ��ȡ��������
  * @param  DevHandle �豸������
  * @param  Channel ��ѹ�����ɼ�ͨ���ţ�����0����
  * @param  pCurrent ����ֵ�洢�������׵�ַ����λΪmA
  * @param  BufferSize ���ݻ���������
  * @retval ʵ�ʻ�ȡ�������ݸ�����С��0����ִ�г���
  */
int WINAPI  PA_GetCurrentData(int DevHandle,int Channel,double *pCurrent,int BufferSize);
/**
  * @brief  ��ȡ��������
  * @param  DevHandle �豸������
  * @param  Channel ��ѹ�����ɼ�ͨ���ţ�����0����
  * @param  pPower ����ֵ�洢�������׵�ַ����λΪmW
  * @param  BufferSize ���ݻ���������
  * @retval ʵ�ʻ�ȡ�������ݸ�����С��0����ִ�г���
  */
int WINAPI  PA_GetPowerData(int DevHandle,int Channel,double *pPower,int BufferSize);
#ifdef __cplusplus
}
#endif


#endif


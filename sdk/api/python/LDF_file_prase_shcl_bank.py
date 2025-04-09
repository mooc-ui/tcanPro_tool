"""
文件说明：USB2XXX PWM测试 - 循环输出并记录时间、频率、占空比、持续时间到日志文件
"""
from ctypes import *
import platform
from time import sleep
from usb_device import *
from usb2pwm import *
import random
from datetime import datetime

from usb2lin_ex import LIN_EX_CtrlPowerOut
#from LDFDecoder import *
#from ldf_parser import *
import ldf_parser

LINIndex = 0           # 通道号
isMaster = 1           # 设置为主设备

if __name__ == '__main__': 
    DevIndex = 0
    DevHandles = (c_int * 20)()
    # 扫描设备
    ret = USB_ScanDevice(byref(DevHandles))

    if(ret == 0):
        print("No device connected!")
        exit()
    else:
        print("Have %d device connected!"%ret)

    # 打开设备
    ret = USB_OpenDevice(DevHandles[DevIndex])
    if(bool(ret)):
        print("Open device success!")
    else:
        print("Open device faild!")
        exit()

    # 获取设备信息
    USB2XXXInfo = DEVICE_INFO()
    USB2XXXFunctionString = (c_char * 256)()
    ret = DEV_GetDeviceInfo(DevHandles[DevIndex],byref(USB2XXXInfo),byref(USB2XXXFunctionString))
    if(bool(ret)):
        print("USB2XXX device infomation:")
        print("--Firmware Name: %s"%bytes(USB2XXXInfo.FirmwareName).decode('ascii'))
        print("--Firmware Version: v%d.%d.%d"%((USB2XXXInfo.FirmwareVersion>>24)&0xFF,(USB2XXXInfo.FirmwareVersion>>16)&0xFF,USB2XXXInfo.FirmwareVersion&0xFFFF))
        print("--Hardware Version: v%d.%d.%d"%((USB2XXXInfo.HardwareVersion>>24)&0xFF,(USB2XXXInfo.HardwareVersion>>16)&0xFF,USB2XXXInfo.HardwareVersion&0xFFFF))
        print("--Build Date: %s"%bytes(USB2XXXInfo.BuildDate).decode('ascii'))
        print("--Serial Number: ",end='')
        for i in range(0, len(USB2XXXInfo.SerialNumber)):
            print("%08X"%USB2XXXInfo.SerialNumber[i],end='')
        print("")
        print("--Function String: %s"%bytes(USB2XXXFunctionString.value).decode('ascii'))
    else:
        print("Get device infomation faild!")
        exit()


    current_dir = os.path.dirname(os.path.abspath(__file__))
    LDFFilePath = os.path.join(current_dir, "FAW_P201_LDF.ldf").encode()
    if not os.path.exists(LDFFilePath.decode()):
        raise Exception("LDF 文件路径不存在: {}".format(LDFFilePath.decode()))

    # Step 1: 解析LDF文件，返回句柄
    ldf_handle = ldf_parser.LDF_ParserFile(DevHandles, LINIndex, isMaster, LDFFilePath)
    if ldf_handle < 0:
        raise Exception("LDF 文件解析失败, 错误码: {}".format(ldf_handle))
    else:
        print(f"LDF 解析成功，句柄值为：{ldf_handle}")


    # Step 2: 获取所有帧的数量
    frame_count = ldf_parser.LDF_GetFrameQuantity(ldf_handle)
    print(f"总共帧数: {frame_count}")
    for i in range(frame_count):
        frame_name = create_string_buffer(256)
        if ldf_parser.LDF_GetFrameName(ldf_handle, i, frame_name) == 0:
            print(f"第{i}帧名：{frame_name.value.decode()}")

    # Step 3: 查找目标帧 "SpeedReq_ECF"
    target_frame = b"SpeedReq_ECF"
    
    found = False

    for i in range(frame_count):
        frame_name = create_string_buffer(256)
        if ldf_parser.LDF_GetFrameName(ldf_handle, i, frame_name) == 0:
            if frame_name.value == target_frame:
                found = True
                break

    if not found:
        raise Exception("未找到帧 SpeedReq_ECF")

    # Step 4: 获取该帧的信号数量
    signal_count = ldf_parser.LDF_GetFrameSignalQuantity(ldf_handle, target_frame)

    # Step 5: 打印信号名称，并选择其中一个信号进行随机值设置
    for idx in range(signal_count):
        signal_name = create_string_buffer(256)
        if ldf_parser.LDF_GetFrameSignalName(ldf_handle, target_frame, idx, signal_name) == 0:
            print("信号{}: {}".format(idx, signal_name.value.decode()))
            # 示例：随机修改第一个信号
            if idx == 0:
                random_value = random.randint(0, 255)
                print(f"设置信号 {signal_name.value.decode()} 为随机值 {random_value}")
                ldf_parser.LDF_SetSignalValue(ldf_handle, target_frame, signal_name, c_uint8(random_value))

    # Step 6: 发送该帧到LIN总线
    result = ldf_parser.LDF_ExeFrameToBus(ldf_handle, target_frame, c_uint8(1))  # 1 表示填充位值
    if result != 0:
        raise Exception("发送帧失败，错误码: {}".format(result))
    else:
        print("帧 SpeedReq_ECF 已成功发送。")        

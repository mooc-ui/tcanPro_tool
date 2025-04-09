"""
文件说明：USB2XXX LIN测试
"""
from ctypes import *
import platform
from time import sleep
from usb_device import *
from usb2pwm import *
import random
from datetime import datetime

from usb2lin_ex import LIN_EX_CtrlPowerOut

import ldf_parser


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

    # 1. 初始化参数
    LINIndex = 0           # LIN通道号
    isMaster = 1           # 主模式
    target_frame_name = b"PDCF_ECFControl"  # 目标帧名（bytes）
    target_signal_name = b"SpeedReq_ECF"    # 目标信号名（bytes）

    # 2. 解析LDF文件
    ldf_handle = ldf_parser.LDF_ParserFile(DevHandles[DevIndex], LINIndex, isMaster, LDFFilePath)
    if ldf_handle <= 0:
        raise Exception(f"LDF解析失败，错误码: {ldf_handle}")

    # 3. 查找目标帧
    frame_count = ldf_parser.LDF_GetFrameQuantity(ldf_handle)
    found_frame = False
    for i in range(frame_count):
        frame_name = create_string_buffer(256)
        if ldf_parser.LDF_GetFrameName(ldf_handle, i, frame_name) == 0:
            if frame_name.value == target_frame_name:
                found_frame = True
                break

    if not found_frame:
        raise Exception(f"未找到帧: {target_frame_name.decode()}")

    # 4. 查找目标信号
    signal_count = ldf_parser.LDF_GetFrameSignalQuantity(ldf_handle, target_frame_name)
    found_signal = False
    for i in range(signal_count):
        signal_name = create_string_buffer(256)
        if ldf_parser.LDF_GetFrameSignalName(ldf_handle, target_frame_name, i, signal_name) == 0:
            if signal_name.value == target_signal_name:
                found_signal = True
                break

    if not found_signal:
        raise Exception(f"未找到信号: {target_signal_name.decode()}")

    # 5. 设置信号值
    random_value = random.randint(0, 255)
    ret = ldf_parser.LDF_SetSignalValue(
        ldf_handle,
        target_frame_name,      # 帧名（bytes）
        target_signal_name,     # 信号名（bytes）
        c_uint8(random_value)   # 值（c_uint8）
    )

    if ret != 0:
        raise Exception(f"设置信号值失败，错误码: {ret}")

    # 6. 发送帧到总线
    ret = ldf_parser.LDF_ExeFrameToBus(
        ldf_handle,
        target_frame_name,  # 帧名（bytes）
        c_uint8(1)          # 填充位值
    )

    if ret != 0:
        raise Exception(f"发送帧失败，错误码: {ret}")

    print(f"成功设置 {target_signal_name.decode()} = {random_value} 并发送帧")
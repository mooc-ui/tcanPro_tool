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

if __name__ == '__main__': 
    DevIndex = 0
    DevHandles = (c_int * 20)()
    # 扫描设备
    ret = USB_ScanDevice(byref(DevHandles))

    #0-LIN1 1-LIN2 2-LIN3 3-LIN4   #设置输出电压
    LIN_EX_CtrlPowerOut(ret, 1)  #设置输出电压
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

    # ✅ 准备日志文件（文件名 = 当前时间）
    start_time_str = datetime.now().strftime("%Y%m%d_%H%M%S")
    log_filename = f"PWM_{start_time_str}.txt"
    log_file = open(log_filename, "w")

    print(f"\n日志文件已创建：{log_filename}\n")

    try:
        while True:
            # 构建 PWM 配置
            PWMConfig = PWM_CONFIG()
            PWMConfig.ChannelMask = 0x40  # CH6

            # 随机占空比
            random_duty = random.randint(1, 100) #生成随机占空比
            # 随机占空比，精度为0.1%
            #random_duty = random.randint(1, 1000) / 10.0  # 生成 0.1% 到 100% 之间的随机占空比

            for i in range(0,8):
                PWMConfig.Polarity[i] = 0  #高有效 低有效设置 将所有PWM通道都设置为正极性
                PWMConfig.Precision[i] = 1000 #将所有通道的占空比调节精度都设置为0.1%  100--> 1%
                #频率计算 frequency = fclk / (PWMConfig.Precision * PWMConfig.Prescaler)  fclk=84M
                PWMConfig.Prescaler[i] = 840*2 #将所有通道的预分频器都设置为10，则PWM输出频率为84MHz/(PWMConfig.Precision*PWMConfig.Prescaler)
                PWMConfig.Pulse[i] = PWMConfig.Precision[i] * random_duty // 100  #占空比 # 将所有通道的占空比都设置为random_duty%
                #PWMConfig.Pulse[i] = PWMConfig.Precision[i] * int(random_duty) // 100
                #PWMConfig.Pulse[i] = PWMConfig.Precision[i] * random_duty / 100
                PWMConfig.Phase[i] = 0

            ret = PWM_Init(DevHandles[DevIndex], byref(PWMConfig))
            if ret != PWM_SUCCESS:
                print("Initialize pwm faild!")
                break

            # 随机时间（1~50000ms）
            runtime_ms = random.randint(1, 40000)  #生成占空比维持的随机时间
            RunTimeOfUs = runtime_ms * 1000

            # ✅ 当前时间戳
            now = datetime.now()
            now_str = now.strftime("%Y-%m-%d %H:%M:%S")

            # ✅ 计算频率
            clk_frequency = 84000000  # 84 MHz
            prescaler = PWMConfig.Prescaler[0]  # 从配置中获取预分频器
            precision = PWMConfig.Precision[0]  # 从配置中获取精度
            pwm_frequency = clk_frequency // (precision * prescaler)  # 计算 PWM 频率

            # ✅ 记录一条数据
            # log_line = f"[{now_str}] 占空比 = {random_duty:>3}%, 持续时间 = {runtime_ms:>5} ms\n"
            log_line = f"[{now_str}] 频率 = {pwm_frequency:>3} hz,占空比 = {random_duty:>6.1f}%, 持续时间 = {runtime_ms:>5} ms\n"
            #log_line = f"[{now_str}] 频率 = {pwm_frequency:>3} hz,占空比 = {PWMConfig.Pulse[6]:>6.1f}%, 持续时间 = {runtime_ms:>5} ms\n"
            print(log_line.strip())
            log_file.write(log_line)
            log_file.flush()

            # 启动PWM
            ret = PWM_Start(DevHandles[DevIndex], PWMConfig.ChannelMask, RunTimeOfUs)
            if ret != PWM_SUCCESS:
                print("Start pwm faild!")
                break

            sleep(runtime_ms / 1000.0)

    except KeyboardInterrupt:
        print("\n用户中断，程序退出")
        USB_CloseDevice(DevHandles[DevIndex])
        log_file.close()

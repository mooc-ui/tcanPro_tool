
from ctypes import *
import platform
from usb_device import *
import os
import ldf_parser

current_dir = os.path.dirname(os.path.abspath(__file__))
LDFFilePath = os.path.join(current_dir, "FAW_P201_LDF.ldf").encode()

print("LDF 文件是否存在？", os.path.exists(LDFFilePath.decode()))
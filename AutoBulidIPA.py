#!/usr/bin/env python
#coding=utf-8
import os
import requests
import webbrowser
import subprocess
import shutil

appPath = '/Users/addcn591/Library/Developer/Xcode/DerivedData/HKHouse591-ettrsrqxqjlrktbzeudyhjyyxjgu/Build/Products/Debug-iphoneos/HKHouse591.app'
payLoadPath = '/Users/addcn591/Desktop/Payload'
packBagPath = '/Users/addcn591/Desktop/HKHouse591'

#编译打包流程
def bulidIPA():
    
    #删除之前打包的HKHouse591文件夹
    subprocess.call(["rm","-rf",packBagPath])
    #创建PayLoad文件夹
    mkdir(payLoadPath)
    #将app拷贝到payLoadPath路径下
    subprocess.call(["cp","-r",appPath,payLoadPath])
    #在桌面上创建HKHouse591的文件夹
    subprocess.call(["mkdir","-p",packBagPath])
    #将payLoadPath文件夹拷贝到HKHouse591文件夹下
    subprocess.call(["cp","-r",payLoadPath,packBagPath])
    #删除桌面的payLoadPath文件夹
    subprocess.call(["rm","-rf",payLoadPath])
    #切换到当前目录
    os.chdir(packBagPath)
    #压缩HKHouse591文件夹下的payLoadPath文件夹夹
    subprocess.call(["zip","-r","./Payload.zip","."])
    print ("\n*************** 打包成功 *********************\n")
    #将zip文件改名为ipa
    subprocess.call(["mv","payload.zip","HKHouse591.ipa"])
    #删除payLoad文件夹
    subprocess.call(["rm","-rf","./Payload"])


#创建PayLoad文件夹
def mkdir(payLoadPath):
    isExists = os.path.exists(payLoadPath)
    if not isExists:
        os.makedirs(payLoadPath)
        print(payLoadPath + '创建成功')
        return True
    else:
        print (payLoadPath + '目录已经存在')
        return False

#上传蒲公英
USER_KEY = "70fb766d779c3f915d372d5ff8266fc8"
API_KEY = "b91a3a9fcaf9a20d7690d13911ef37f7"
openUrlPath = 'https://www.pgyer.com/manager/dashboard/app/5dc2ec2c5c1ab02f74a52055b144263f'

#上传蒲公英
def uploadIPA(IPAPath):
    if(IPAPath==''):
        print("\n*************** 没有找到对应上传的IPA包 *********************\n")
        return
    else:
        print("\n***************开始上传到蒲公英*********************\n")
        url='http://www.pgyer.com/apiv1/app/upload'
        data={
            'uKey':USER_KEY,
            '_api_key':API_KEY,
            'installType':'2',
            'password':'',
            'updateDescription':""
        }
        files={'file':open(IPAPath,'rb')}
        r=requests.post(url,data=data,files=files)

def openDownloadUrl():
    webbrowser.open(openUrlPath,new=1,autoraise=True)
    print ("\n*************** 更新成功 *********************\n")

if __name__ == '__main__':
    bulidIPA()
    uploadIPA('%s/HKHouse591.ipa'%packBagPath)
    openDownloadUrl()

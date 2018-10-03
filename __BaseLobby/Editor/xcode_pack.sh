#!/bin/sh
CONFIG_ROOT_PATH=$1
cd $CONFIG_ROOT_PATH
#循环数组
CHANNELID=($2)
#.app的名字
APPNAME=($3)
for ((i=0;i<${#CHANNELID[@]};i++))
do
#删除
rm -rf "${CONFIG_ROOT_PATH}/build/"

#清除
  xcodebuild -target Unity-iPhone clean
    #修改plist
    #/usr/libexec/PlistBuddy -c "set :CHANNELID ${CHANNELID[$i]}" /Users/admin/Desktop/yourproject/woMusic/AppConfig.plist
#打包
    xcodebuild -target Unity-iPhone -configuration Distribution -sdk iphoneos build
    #生成ipa
    xcrun -sdk iphoneos PackageApplication -v "${CONFIG_ROOT_PATH}/build/Release-iphoneos/${APPNAME}.app" -o "${CHANNELID[$i]}"
done

#!/bin/sh

#export LC_ALL=zh_CN.GB2312;export LANG=zh_CN.GB2312
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#项目路径,jenkins环境下的项目所在路径,
# /Users/你的电脑名称/.jenkins/workspace/项目名称(此处项目名称与jenkins上的一致)
projectDir=/Users/xxx/.jenkins/workspace/AutoDemo

#打包需要的ExportOptions.plist文件路径
#ExportOptions.plist的内容可以通过xcodebuild -help了解
exportOptionsPlistPath=${projectDir}/ExportOptions.plist

#项目名称,工程名称
projectName=AutoDemo
#编译的方式,默认为Release,还有Debug等
buildConfig=Release 
#日志log文件/导出安装包的目录路径
buildAppToDir=/Users/xxx/Desktop/demoIpa

#项目的Info.plist路径
infoPlist=${projectDir}/${projectName}/Info.plist

#由于jenkins拉下来的项目无法获取到分支名，这里进行手动修改配置
#GIT_BRANCH 是jenkins提供的变量名,得到分支名称
/usr/libexec/PlistBuddy -c "Set :GitCommitBranch ${GIT_BRANCH/#origin\//}" $infoPlist

mkdir -pv $buildAppToDir
logPath=$buildAppToDir/$projectName-$buildConfig.log

###############
mkdir -pv $buildAppToDir

#用到cocoapods,需要更新Pods的执行下命令,不需要则可注释
#cd $projectDir
#pod install

###############开始编译app

echo "分支名称: ${GIT_BRANCH/#origin\//}" >>$logPath

#编译前先clean
xcodebuild clean
#使用cocoapods的项目  workspace的，则执行此行
# xcodebuild -workspace ${projectDir}/${projectName}.xcworkspace -scheme ${projectName} -configuration $buildConfig -sdk iphoneos -archivePath $buildAppToDir/$projectName.xcarchive archive

#project,非workspace项目执行此行
xcodebuild -project ${projectDir}/${projectName}.xcodeproj -scheme ${projectName} -configuration $buildConfig -sdk iphoneos -archivePath $buildAppToDir/$projectName.xcarchive archive

#判断编译结果
if test $? -eq 0
then
echo "~~~~~~~~~~~~~~~~~~~编译成功~~~~~~~~~~~~~~~~~~~" >>$logPath
else
echo "~~~~~~~~~~~~~~~~~~~编译失败~~~~~~~~~~~~~~~~~~~" >>$logPath
echo "\n" >>$logPath
exit 1
fi

###############开始打包成.ipa 
ipaName="`date +%Y%m%d%-H:%m:%s`" 
echo "安装包名称:${ipaName}" >>$logPath

echo "开始打包$projectName.xcarchive成$projectName.ipa....." >>$logPath

xcodebuild -exportArchive -archivePath ${buildAppToDir}/${projectName}.xcarchive -exportPath ${buildAppToDir}/${ipaName}.ipa -exportOptionsPlist ${exportOptionsPlistPath} -allowProvisioningUpdates

if test $? -eq 0
then
    #statements
    echo "打包${projectName}的ipa包成功" >>$logPath
else
    echo "打包${projectName}的ipa包失败" >>$logPath
    exit 1
fi


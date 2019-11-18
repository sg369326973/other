#/bin/bash

#计时

SECONDS=0

#项目路径

project_path="$PWD/Desktop/hk591/hk591/apps/ios/HKHouse591"

#项目scheme名称

scheme="HKHouse591"

#指定要打包的配置名 Release, Debug

configuration="Debug"

#指定打包所使用的输出方式，目前支持app-store, package, ad-hoc, enterprise, development, 和developer-id，即xcodebuild的method参数

export_method='development'

#指定项目地址

workspace_path="$project_path/${scheme}.xcworkspace"

#Info.plist文件路径

info_plist_path="$project_path/${scheme}/Config/Plist/Info.plist"

#获取Plist标题

bundleName=$(/usr/libexec/PlistBuddy -c "print CFBundleName" ${info_plist_path})

#获取Plist版本号

bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" ${info_plist_path})

#指定输出路径

output_path="$PWD/Desktop/APP版本/${bundleVersion}"

#指定输出归档文件地址

archive_path="$output_path/${scheme}.xcarchive"

#指定输出ipa地址

ipa_path="$output_path/${scheme}.ipa"

#指定输出ipa名称

ipa_name="${scheme}.ipa"

#获取执行命令时的commit message

commit_msg="$1"

#输出设定的变量值

echo "===workspace path: ${workspace_path}==="

echo "===archive path: ${archive_path}==="

echo "===ipa path: ${ipa_path}==="

echo "===export method: ${export_method}==="

echo "===bundleName: $bundleName==="

echo "===bundleVersion: $bundleVersion==="

#打包生成ipa

fastlane gym --workspace ${workspace_path} --scheme ${scheme} --clean --configuration ${configuration} --archive_path ${archive_path} --export_method ${export_method} --output_directory ${output_path} --output_name ${ipa_name}

#------------------------------------------

#上传到Bugly

#bugly_app_key="687e802b-6650-4082-9d18-719115acd972"

#bugly_app_id="0dbc768607"

#bugly_pid="2"

#项目名称加版本号
#bugly_title="$bundleName$bundleVersion"

#版本上传地址
#bugly_upload_url="https://api.bugly.qq.com/beta/apiv1/exp?app_key=${bugly_app_key}"

#查询当前当前最新版Json
#bugly_latest_json=$(curl --insecure "https://api.bugly.qq.com/beta/apiv1/exp_list?app_id=${bugly_app_id}&pid=${bugly_pid}&app_key=${bugly_app_key}&start=0&limit=1" | jq ".data.list[0]")

#最新版本号
#bugly_latest_version=$(echo $bugly_latest_json | jq ".version" | sed 's/\"//g')
#echo "===bugly_latest_version: $bugly_latest_version==="

#最新版本expid
#bugly_latest_expid=$(echo $bugly_latest_json | jq ".exp_id" | sed 's/\"//g')
#echo "===bugly_latest_expid: $bugly_latest_expid==="

#判断如果最新版本与本地版本一致就替换版本，否则新发布一个版本
#if [ "$bugly_latest_version" = "$bundleVersion" ]; then
    #版本替换
#    echo "===版本替换...==="
#    curl --insecure -X "PUT" -F "file=@${ipa_path}" -F "exp_id=${bugly_latest_expid}" -F "title=${bugly_title}" $bugly_upload_url
#else
    #版本发布
#    echo "===版本上传...==="
#    curl --insecure -F "file=@${ipa_path}" -F "app_id=${bugly_app_id}" -F "pid=${bugly_pid}" -F "title=${bugly_title}" $bugly_upload_url
#fi

#------------------------------------------

#上传到蒲公英

pgyer_user_key="70fb766d779c3f915d372d5ff8266fc8"

pgyer_api_key="b91a3a9fcaf9a20d7690d13911ef37f7"

#上传地址
pgyer_upload_url="https://qiniu-storage.pgyer.com/apiv1/app/upload"

#执行上传
curl -F "file=@${ipa_path}" -F "uKey=${pgyer_user_key}" -F "_api_key=${pgyer_api_key}" $pgyer_upload_url

#输出总用时
echo "===Finished. Total time: ${SECONDS}s==="

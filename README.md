
***目标：实现类似前端打包一样的配置，与git分支做匹配，自动化部署环境，同时提供接口支持应用内切换环境***

***注意配置好之后，需要Clean一遍项目,不然会报错GitCommitBranch不存在***
####在项目中获取git信息
1. 在Info.plist增加GitCommitBranch（名字自定，表达清晰即可）项，用于记录分支名称
2. 在 Xcode(TARGETS项目target) - Build Phases - New Run Script Phase，增加脚本配置，用于获取git信息并更新到Info.plist中, 脚本代码如下

```
#当前的分支
git_branch=$(git symbolic-ref --short -q HEAD)

#获取App安装包下的info.plist文件路径
info_plist="${BUILT_PRODUCTS_DIR}/${EXECUTABLE_FOLDER_PATH}/Info.plist"

#利用PlistBuddy改变info.plist的值
/usr/libexec/PlistBuddy -c "Set :'GitCommitBranch'    '${git_branch}'"                 "${info_plist}"

```

创建配置文件，实现API环境自动部署
创建AutoConfig单例，实现自动化部署逻辑，提供一切受环境影响的接口供外部调用即可


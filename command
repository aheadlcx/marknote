// 设置代理 export ALL_PROXY=socks5://127.0.0.1:1080 // 清除代理 unset ALL_PROXY // 查看ip测试是否生效 curl -i http://ip.cn


alias setproxy="export ALL_PROXY=socks5://127.0.0.1:1086" alias unsetproxy="unset ALL_PROXY"



# 查看 git log ，列出变更的文件
alias glno="git log --name-only"
# 查看一个文件的变更历史，单行显示 git log --pretty=oneline filepath
# 查看一个文件的变更历史 git log filepath
# brew install tig 查看 git 历史对比的
# tig usage https://jonas.github.io/tig/doc/tig.1.html



创建区分大小写的磁盘映像
您可以使用磁盘映像在现有的 Mac OS 环境中创建区分大小写的文件系统。要创建磁盘映像，请启动磁盘工具，然后选择“新建映像”。完成编译至少需要 25GB 空间；更大的空间能够更好地满足未来的需求。使用稀疏映像有助于节省空间，而且以后可以随着需求的增加进行扩展。请务必选择“Case sensitive, Journaled”存储卷格式。

您也可以通过 shell 使用以下命令创建磁盘映像：

# hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 40g ~/android.dmg
这将创建一个 .dmg（也可能是 .dmg.sparseimage）文件，该文件在装载后可用作具有 Android 开发所需格式的存储卷。

如果您以后需要更大的存储卷，还可以使用以下命令来调整稀疏映像的大小：

# hdiutil resize -size <new-size-you-want>g ~/android.dmg.sparseimage

对于存储在主目录下的名为 android.dmg 的磁盘映像，您可以向 ~/.bash_profile 中添加辅助函数：

要在执行 mountAndroid 时装载磁盘映像，请运行以下命令：
# mount the android file image
function mountAndroid { hdiutil attach ~/android.dmg -mountpoint /Volumes/android; }
注意：如果系统创建的是 .dmg.sparseimage 文件，请将 ~/android.dmg 替换成 ~/android.dmg.sparseimage。

要在执行 umountAndroid 时卸载磁盘映像，请运行以下命令：

# unmount the android file image
function umountAndroid() { hdiutil detach /Volumes/android; }
装载 android 存储卷后，您将在其中开展所有工作。您可以像对待外接式存储盘一样将其弹出（卸载）。


git commit --amend --date="$(date -R)"   //work
git commit --amend --date=`date -R`    / not work

log file navigator
lnav

An advanced log file viewer for the small-scale


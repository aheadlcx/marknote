// 设置代理 export ALL_PROXY=socks5://127.0.0.1:1080 // 清除代理 unset ALL_PROXY // 查看ip测试是否生效 curl -i http://ip.cn


alias setproxy="export ALL_PROXY=socks5://127.0.0.1:1086" alias unsetproxy="unset ALL_PROXY"



# 查看 git log ，列出变更的文件
alias glno="git log --name-only"
# 查看一个文件的变更历史，单行显示 git log --pretty=oneline filepath
# 查看一个文件的变更历史 git log filepath
# brew install tig 查看 git 历史对比的
# tig usage https://jonas.github.io/tig/doc/tig.1.html
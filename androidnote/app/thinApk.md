
## apk 瘦身
[爱奇艺瘦身](https://juejin.im/entry/59cdbbd06fb9a00a59597c4b)
占比大头是 libs res dex .
瘦身思路

+ apk 插件化
+ 使用apksigner签名
+ 一套资源 xhdpi
+  重复资源 和 无用资源
+ png 图片
+ 代码方面
+ libs 方面


### 使用apksigner签名
对比未签名的APK，用jarsigner签名工具签名，APK里面所有压缩后的文件和文件夹体积都增大了；而apksigner签名工具签名，除了META_INF文件夹增大了以外，其它文件和文件夹的大小都没有改变。

产生上述变化的原因是：

jarsigner是针对每个文件进行了签名，然后针对签名后的文件计算摘要，并写入到META-INF文件夹下的MANIFEST.MF文件里面；而apksigner直接计算所有文件的摘要，写入MANIFEST.MF文件。

### 一套资源 
综合考虑图片清晰度，静态大小和内存占用情况，一般采用 xhdpi 下的资源图片。

###  重复资源
很多时候，随着工程的增大，以及开发人员的变动，有些资源文件名字不同，但是内容却完全相同。我们可以通过扫描文件的MD5值，找出名字不同，内容相同的图片并删除，做到图片不重复。并且删除无用资源。

### png 图片

+ tinypng API 自动化压缩。 python 脚本
+ 4.2 webP ，4.0 4.1 仅仅支持不包含透明度的有损压缩。python，遍历查找，不包含透明度的图片，再进行 webP 转化。
+ 第三方库中的大图，没有用到的话，就采用 1*1 的透明图片。

### 代码方面

+ [无用和重复代码扫描，注意反射调用](https://github.com/SonarSource/sonarqube)
+ 删除R文件，或者适当压缩R文件,可以 [蘑菇街的实战](https://github.com/meili/ThinRPlugin/blob/9fe13a06b05ef7971bbe3ddbd101110e35df3361/README.zh-cn.md)
+ 注解代替枚举 ，减少体积和应用时内存。枚举编译后的 class ，每一个枚举都是一个对象，还有一个 value 数组。注解，就是一个常量了，在编译后。

### lib 方面
+ 仅仅保留主流框架，x86 考虑不支持。仅保留 armeabi 一套。
+ so 的插件化，例如 RN 的。

### 总结
+ webP 转化要注意资源拼接。
+ 使用apksigner签名工具前，必须先执行zipalign操作；而使用jarsigner签名工具则是先签名，然后再用zipalign优化。

## APK 搜身的第三方工具
	
	+ [安装包立减1M--微信Android资源混淆打包工具](https://cloud.tencent.com/developer/article/1030753)  注意点，linux与mac的7z效果更好

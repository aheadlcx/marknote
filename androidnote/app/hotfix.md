[微信Tinker的一切都在这里，包括源码(一)](https://mp.weixin.qq.com/s/HZDVSsEzmitNLuPP8HjbHw)
[Tinker：技术的初心与坚持](https://mp.weixin.qq.com/s/tlDy6kx8qVHQOZjNpG514w)
[微信 Tinker 负责人张绍文关于 Android 热修复直播分享记录](https://www.diycode.cc/topics/231)

## 热修复方案对比

需要解决的问题

+ 代码热修复
+ 资源热修复
+ so 库的热修复
+ Application 的修复

目前市面上有的方案

* 阿里百川 HotFix
* 阿里 Sophix
* QQ 空间方案
* Tinker
* Instant App
* 饿了么 Amigo
* 美团的 Robust

### 阿里百川 HotFix
C层修改方法体，不包括资源和SO方面的热修复。修改方法体底层，稳定性，也不一定靠谱。

### 阿里 Sophix 方案
#### 代码方面的修复
包含以下2个方面

+ 底层方法体替换
+ 全量 dex 合成，类的角度。

##### ART 下，
已经支持多 dex 的加载，把 补丁 dex ，改成 class.dex ，后面的类推。那么重复的补丁类就不会加载了。是把 补丁 dex 和原来 dex ，合并成一个压缩包。加载比较耗时。

##### Dvm 下，
去除基线包中的需要修复的类的定义，class的内容，不改。

#### 资源方面的修复
##### 在 Android L 以后的版本，
把改变的资源项的，新打一个资源包，package ID 改为 0x66 。直接在原来的 AssetManager 上 addAssetPath 即可。
新增资源，新代码引用即可。删除资源，不适用就可以了。改变资源，视为新增资源，并且在代码引用出，改为新的ID
##### 在 Android 以下版本
则是先释放原先的资源（ destory 方法），再 init 添加资源进去。

##### so 库的修复
把  so 补丁库，插入到 nativeLibraryDirectories 数组前面。


### QQ 空间方案
插入一个 dex ，在前面。
apk 第一次安装的时候，会进行

+ dvmVerifyClass ，类校验。
+ dvmOptimizeClass 类优化

一个单独 dex ，有一个单独的类，让所有的类，构造函数中都引用这个类，防止打上 Class_ISPRVERIFIED .
缺点是，在安装时，所有的类都没有执行 verify 和 Optimze，都会在运行时执行。

### Tinker 方案
全量 dex 合成。从 dex 的方法和指令维度进行合成。
分平台合成:

+ Dalvik全量合成，解决了插桩带来的性能损耗；
+ Art平台合成small dex，解决了全量合成方案占用Rom体积大, OTA升级以及Android N的问题；
+ 大部分情况下Art.info仅仅1-20K, 解决由于补丁包可能过大的问题；

### Instant App 方案

#### 在资源的处理上
构造新 AssetManager ，并且加上完整新的资源包，通过反射，取代之前所有的引用出。

### Application 的修复
Tinker 是把 用户代码和 application 隔离了，这就不需要热修复了。
阿里 Sopix 是把 application 用到的代码，尽可能打包到 main dex 中。
#### 资源层面
构造新的 AssetManager ，addAssetPath 添加资源，然后替换所有引用到旧 AssetManager 。
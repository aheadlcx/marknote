### Android 知识积累
+ Android 构建过程
+ java内存GC 原理。
+ hashmap 原理
+ 线性安全
+ http & https
+ New Android Version Feature
+ 容器 SparseArray 和 ArrayMap 代替HashMap
+ ANR 的定位 
+ OOM 的定位 
+ 性能优化工具的使用 
+ Glide 图片加载 undo
+ 进程的同步
+ apk 瘦身
+ 热修复-阿里热修复手册
+ 插件化-small undo
+ IPC undo

#### java GC 内存原理
[杰风居-理解java垃圾回收机制](http://jayfeng.com/2016/03/11/%E7%90%86%E8%A7%A3Java%E5%9E%83%E5%9C%BE%E5%9B%9E%E6%94%B6%E6%9C%BA%E5%88%B6/)

#### hashmap 原理
[美团点评hasmmap](https://tech.meituan.com/java-hashmap.html)
![hashmap 数据结构](https://tech.meituan.com/img/java-hashmap/hashMap%E5%86%85%E5%AD%98%E7%BB%93%E6%9E%84%E5%9B%BE.png)

+ 数组+链表+红黑树 实现
+ hash 越均匀，越好。
+ hash  = key.hashCode() ^ (key.hashCode() >>> 16)，异或运算，高低16位，都参与。
![hashmap key 运算](https://tech.meituan.com/img/java-hashmap/hashMap%E5%93%88%E5%B8%8C%E7%AE%97%E6%B3%95%E4%BE%8B%E5%9B%BE.png)
+ hashmap 底层数组长度总是2的n次方，h & (length -1) 运算，刚好是对 length 取模运算，就是 h % length ，但是 & 比 %  有效率。
+ hashmap 不安全，可以考虑用 ConcurrentHashMap （分段锁，并发性优于 Hashtable）。
+ hashmap 桶数，取质数，有什么优点。取2的n次方，
	++ 缺点是，导致某些位失效了。
	++ 优点是，hashmap的 indexFor 函数 h & (length - 1) 刚好是对 length 取模，效率高。

#### 线性安全
java内存模型
+ 主内存和工作内存
+ 原子性、可见性和有序性。
	+ 原子性：原子性意味着个时刻，只有一个线程能够执行一段代码
	+ 可见性：如果一个线程修改了这个共享 变量，那么其他线程应该能够看到这个被修改后的值，这就是多线程的可见性问题
	+ 有序性：线程在引用变量时不能直接从主内存中引用,如果线程工作内存中没有该变量,则会从主内存中拷贝一个副本到工作内存中,这个过程为read-load,完 成后线程会引用该副本。当同一线程再度引用该字段时,有可能重新从主存中获取变量副本(read-load-use),也有可能直接引用原来的副本 (use)

+ synchronized 和 volatile
	+ volatile 有可见性和禁止指令重排
	+ synchronized 有原子性和可见性，有序性。


#### http https


#### SparseArray 和 ArrayMap 代替 HashMap

+ SparseArray ，采用2个数组来储存。一个 key 数组，一个 value 数组。key 是升序排序的。查找 key 是，二分法。
+ ArrayMap ，采用2个数组来储存。一个 key 的 hash 数组，一个是 key 和 value ，依次排序的数组。查找 key 是，二分法。

数组的大小，没有多余，因此省了内存。 SparseArray 和 ArrayMap 的 key ，在数据量少的时候，查找快。数据量大的时候，反而会降低大概50%。

#### ANR 的定位
adb pull /data/anr/traces.txt 再定位

#### apk 瘦身
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


##### 使用apksigner签名
对比未签名的APK，用jarsigner签名工具签名，APK里面所有压缩后的文件和文件夹体积都增大了；而apksigner签名工具签名，除了META_INF文件夹增大了以外，其它文件和文件夹的大小都没有改变。

产生上述变化的原因是：

jarsigner是针对每个文件进行了签名，然后针对签名后的文件计算摘要，并写入到META-INF文件夹下的MANIFEST.MF文件里面；而apksigner直接计算所有文件的摘要，写入MANIFEST.MF文件。

##### 一套资源 
综合考虑图片清晰度，静态大小和内存占用情况，一般采用 xhdpi 下的资源图片。

#####  重复资源
很多时候，随着工程的增大，以及开发人员的变动，有些资源文件名字不同，但是内容却完全相同。我们可以通过扫描文件的MD5值，找出名字不同，内容相同的图片并删除，做到图片不重复。并且删除无用资源。

##### png 图片

+ tinypng API 自动化压缩。 python 脚本
+ 4.2 webP ，4.0 4.1 仅仅支持不包含透明度的有损压缩。python，遍历查找，不包含透明度的图片，再进行 webP 转化。
+ 第三方库中的大图，没有用到的话，就采用 1*1 的透明图片。

##### 代码方面

+ [无用和重复代码扫描，注意反射调用](https://github.com/SonarSource/sonarqube)
+ 删除R文件，或者适当压缩R文件,可以 [蘑菇街的实战](https://github.com/meili/ThinRPlugin/blob/9fe13a06b05ef7971bbe3ddbd101110e35df3361/README.zh-cn.md)
+ 注解代替枚举 ，减少体积和应用时内存。枚举编译后的 class ，每一个枚举都是一个对象，还有一个 value 数组。注解，就是一个常量了，在编译后。

##### lib 方面
+ 仅仅保留主流框架，x86 考虑不支持。仅保留 armeabi 一套。
+ so 的插件化，例如 RN 的。

##### 总结
+ webP 转化要注意资源拼接。
+ 使用apksigner签名工具前，必须先执行zipalign操作；而使用jarsigner签名工具则是先签名，然后再用zipalign优化。
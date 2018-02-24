### Android 知识积累
+ Android 构建过程
+ java内存GC 原理。
+ hashmap 原理
+ 线性安全
+ http & https
+ New Android Version Feature
+ 容器 SparseArray和ArrayMap代替HashMap
+ ANR 的定位 undo 
+ OOM 的定位 undo
+ 性能优化工具的使用 undo
+ Glide 图片加载 undo
+ 进程的同步

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


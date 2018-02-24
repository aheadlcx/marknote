### Android 知识积累
+ Android 构建过程
+ java内存GC 原理。
+ hashmap 原理

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
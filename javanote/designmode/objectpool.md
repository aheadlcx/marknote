## 设计模式 -- 对象池
在 Android 源码中，经典的就是 Message 的设计了。

2个关键的方法 如下，关键实现点，

* 获取的时候，就是用一个静态变量 sPool 代表，当前缓存池，头部的节点，当获取一个对象的时候，就把 sPool 给你，并且把 sPool 指向下一个节点，并且把准备返回的对象 next = null ，防止不恰当的引用。
* 回收的时候，先判断一下，是否达到了缓存的最大值，然后把要回收的对象，置为当前缓存链表的头部位置。

这个用链表来实现缓存池，比用数组来数显，效率更高了，因为数组需要遍历，才知道那个对象是没有在使用状态。链表的话，直接拿下一个对象就是了。

````java
    private static Message sPool;
    // sometimes we store linked lists of these things
    /*package*/ Message next;
    private static final Object sPoolSync = new Object();

    public static Message obtain() {
        synchronized (sPoolSync) {
            if (sPool != null) {
                Message m = sPool;
                sPool = m.next;
                m.next = null;
                m.flags = 0; // clear in-use flag
                sPoolSize--;
                return m;
            }
        }
        return new Message();
    }
````


````java
    void recycleUnchecked() {
        // Mark the message as in use while it remains in the recycled object pool.
        // Clear out all other details.
        flags = FLAG_IN_USE;
        what = 0;
        arg1 = 0;
        arg2 = 0;
        obj = null;
        replyTo = null;
        sendingUid = -1;
        when = 0;
        target = null;
        callback = null;
        data = null;

        synchronized (sPoolSync) {
            if (sPoolSize < MAX_POOL_SIZE) {
                next = sPool;
                sPool = this;
                sPoolSize++;
            }
        }
    }

````
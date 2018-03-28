## 线程池
ThreadPoolExecutor 构造函数如下：

````java
        ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(
                CORE_POOL_SIZE, MAXIMUM_POOL_SIZE, KEEP_ALIVE_SECONDS, TimeUnit.SECONDS,
                sPoolWorkQueue, sThreadFactory);
````


+ CORE_POOL_SIZE 核心线程数量，默认一直活着。 poolExecutor.allowCoreThreadTimeOut(true) 设置之后，就可以有超时策略。
+ MAXIMUM_POOL_SIZE 线程池最大线程数，当活动线程达到这个值之后，后续的就会被阻塞。
+ KEEP_ALIVE_SECONDS 非核心线程的超时时长。
+ sPoolWorkQueue 线程池的任务队列
+ sThreadFactory ，为线程池提供线程的工厂方法。
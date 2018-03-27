## 线性安全
实现线程安全的方法

* 互斥同步
* 非阻塞同步

### 互斥同步
互斥同步，有下面几种实现方式

* 临界区
* 互斥量
* 信号量

#### 临界区

* synchronized
* ReentrantLock
* Object Wait 和 notify/notifyAll 方法 

##### ReentrantLock 有以下几个特点

* 等待可中断 lockInterruptibly
* 公平锁 是否按照申请锁的时间来决定顺序
* 锁绑定多个条件

[等待可中断，示例](http://www.iteedu.com/plang/java/superjava/threadsafe/lockInterruptibly.php)

锁绑定多个条件

````java
// lock and condition variables
    private final Lock aLock = new ReentrantLock();
    private final Condition bufferNotFull = aLock.newCondition();
    private final Condition bufferNotEmpty = aLock.newCondition();
 public void put() throws InterruptedException {
        aLock.lock();
        try {
            while (queue.size() == CAPACITY) {
                System.out.println(Thread.currentThread().getName()
                        + " : Buffer is full, waiting");
                bufferNotEmpty.await();
            }

            int number = theRandom.nextInt();
            boolean isAdded = queue.offer(number);
            if (isAdded) {
                System.out.printf("%s added %d into queue %n", Thread
                        .currentThread().getName(), number);

                // signal consumer thread that, buffer has element now
                System.out.println(Thread.currentThread().getName()
                        + " : Signalling that buffer is no more empty now");
                bufferNotFull.signalAll();
            }
        } finally {
            aLock.unlock();
        }
    }

     public void get() throws InterruptedException {
        aLock.lock();
        try {
            while (queue.size() == 0) {
                System.out.println(Thread.currentThread().getName()
                        + " : Buffer is empty, waiting");
                bufferNotFull.await();
            }

            Integer value = queue.poll();
            if (value != null) {
                System.out.printf("%s consumed %d from queue %n", Thread
                        .currentThread().getName(), value);

                // signal producer thread that, buffer may be empty now
                System.out.println(Thread.currentThread().getName()
                        + " : Signalling that buffer may be empty now");
                bufferNotEmpty.signalAll();
            }

        } finally {
            aLock.unlock();
        }
    }

````


ReentrantReadWriteLock 是 写入和写入互斥，读取和写入互斥，读取和读取之间不互斥。

##### Object Wait 
Object.wait(timeout) ，超时之后，必须判断一下，是超时了，还是被 notify 了。检查是否持有锁了，可以用 Thread.holdsLock( Object obj)

#### 互斥量

#### 信号量

#### 锁的实现
LockSupport.park

LockSupport.unpark

都是通过 native 方法实现的阻塞锁

````java
    public static void park(Object blocker) {
        Thread t = Thread.currentThread();
        setBlocker(t, blocker);
        UNSAFE.park(false, 0L);
        setBlocker(t, null);
    }
````


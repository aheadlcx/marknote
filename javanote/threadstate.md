## 线程的状态
    
    * 新建状态
    * 就绪状态 Runnable，等待线程调度选中，获得CPU时间片
    * 运行状态 
    * 无限期等待 ，没有设置 TimeOut 的 Object.wait Thread.join LockSupport.park
    * 有限期等待，设置了 TimeOut 的 wait join ,Thread.Sleep
    * 阻塞状态，在等待获得一个排他锁
    * 结束 Terminated
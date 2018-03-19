## 常用 RxJava 操作符
[引用处](https://www.jianshu.com/p/3fdd9ddb534b)

* timer(1000, TimeUnit.MILLISECONDS)
* Observable.interval(1, TimeUnit.SECONDS) interval： 创建一个按照给定的时间间隔发射从0开始的整数序列的
*  Observable.range(2,5)  range： 创建一个发射指定范围的整数序列的Observable<Integer>

````java
Observable.range(2,5).subscribe(new Action1<Integer>() {
        @Override
        public void call(Integer integer) {
            Log.d("JG",integer.toString());// 2,3,4,5,6 从2开始发射5个数据
        }
    });

作者：maplejaw_
链接：https://www.jianshu.com/p/3fdd9ddb534b
來源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
````

* Observable.defer 只有当订阅者订阅才创建Observable，为每个订阅创建一个新的Observable。内部通过OnSubscribeDefer在订阅时调用Func0创建Observable。

````java
Observable.defer(new Func0<Observable<String>>() {
        @Override
        public Observable<String> call() {
            return Observable.just("hello");
        }
    }).subscribe(new Action1<String>() {
        @Override
        public void call(String s) {
            Log.d("JG",s);
        }
    });
````

* concat 按顺序连接多个Observables。需要注意的是Observable.concat(a,b)等价于a.concatWith(b)。
* startWith 在数据序列的开头增加一项数据。startWith的内部也是调用了concat
* merge 将多个Observable合并为一个。不同于concat，merge不是按照添加顺序连接，而是按照时间线来连接。其中mergeDelayError将异常延迟到其它没有错误的Observable发送完毕后才发射。而merge则是一遇到异常将停止发射数据，发送onError通知。
* zip 使用一个函数组合多个Observable发射的数据集合，然后再发射这个结果。如果多个Observable发射的数据量不一样，则以最少的Observable为标准进行压合。内部通过OperatorZip进行压合。
* filter 过滤数据。内部通过OnSubscribeFilter过滤数据。
* ofType 
* take 只发射开始的N项数据或者一定时间内的数据。内部通过OperatorTake和OperatorTakeTimed过滤数据。
* takeFirst 提取满足条件的第一项。内部实现源码如下：
* takeLast 只发射最后的N项数据或者一定时间内的数据。内部通过OperatorTakeLast和OperatorTakeLastTimed过滤数据。takeLastBuffer和takeLast类似，不同点在于takeLastBuffer会收集成List后发射。
* first/firstOrDefault 只发射第一项（或者满足某个条件的第一项）数据，可以指定默认值。







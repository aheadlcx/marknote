## Android 上面遇到的特殊问题 --  Toast 引起的 TransactionTooLargeException

[Google 关于 TransactionTooLargeException](https://developer.android.com/reference/android/os/TransactionTooLargeException.html)

bug log 如下

````java
value2:1005; time:2016-11-24 16:23:31java.lang.RuntimeException: Adding window failed
at android.view.ViewRootImpl.setView(ViewRootImpl.java:515)
at android.view.WindowManagerGlobal.addView(WindowManagerGlobal.java:259)
at android.view.WindowManagerImpl.addView(WindowManagerImpl.java:69)
at android.widget.Toast$TN.handleShow(Toast.java:416)
at android.widget.Toast$TN$1.run(Toast.java:324)
at android.os.Handler.handleCallback(Handler.java:733)
at android.os.Handler.dispatchMessage(Handler.java:95)
at android.os.Looper.loop(Looper.java:136)
at android.app.ActivityThread.main(ActivityThread.java:5120)
at java.lang.reflect.Method.invokeNative(Native Method)
at java.lang.reflect.Method.invoke(Method.java:515)
at com.android.internal.os.ZygoteInit$MethodAndArgsCaller.run(ZygoteInit.java:818)
at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:634)
at dalvik.system.NativeStart.main(Native Method)
Caused by: android.os.TransactionTooLargeException
at android.os.BinderProxy.transact(Native Method)
at android.view.IWindowSession$Stub$Proxy.addToDisplay(IWindowSession.java:684)
at android.view.ViewRootImpl.setView(ViewRootImpl.java:504)
... 13 more
tid: 1

currentVersion=8490
packageChannelID=201

timestamp:1479975811523 record size:0numTrySend=1;;isAppUpgradeFirstStart=true;; classname: top_act:.app.lockscreen.LockScreenActivity;
````

根据 TransactionTooLargeException 的解释，就是 传递过来给 Binder Server 或者 Binder Server 回传的 参数太大了，所以出现这个 bug 了。这个大多数情况。除此之外，还可能是：

1. 整个进程，The Binder transaction buffer ，就 1MB，某一个 binder 请求太大，或者短时间内，太多 binder 请求，也会发生这个情况。
2. 对应的FD ，已经被关闭了
3. the transaction is malformed ，这个请求是有缺陷的。这个缺陷，不知道有哪些场景。

在源码中的 android_util_Binder.cpp 的 signalExceptionForError 方法 有如下注解

````java
        case FAILED_TRANSACTION: {
            ALOGE("!!! FAILED BINDER TRANSACTION !!!  (parcel size = %d)", parcelSize);
            const char* exceptionToThrow;
            char msg[128];
            // TransactionTooLargeException is a checked exception, only throw from certain methods.
            // FIXME: Transaction too large is the most common reason for FAILED_TRANSACTION
            //        but it is not the only one.  The Binder driver can return BR_FAILED_REPLY
            //        for other reasons also, such as if the transaction is malformed or
            //        refers to an FD that has been closed.  We should change the driver
            //        to enable us to distinguish these cases in the future.
            if (canThrowRemoteException && parcelSize > 200*1024) {
                // bona fide large payload
                exceptionToThrow = "android/os/TransactionTooLargeException";
                snprintf(msg, sizeof(msg)-1, "data parcel size %d bytes", parcelSize);
            } else {
                // Heuristic: a payload smaller than this threshold "shouldn't" be too
                // big, so it's probably some other, more subtle problem.  In practice
                // it seems to always mean that the remote process died while the binder
                // transaction was already in flight.
                exceptionToThrow = (canThrowRemoteException)
                        ? "android/os/DeadObjectException"
                        : "java/lang/RuntimeException";
                snprintf(msg, sizeof(msg)-1,
                        "Transaction failed on small parcel; remote process probably died");
            }
            jniThrowException(env, exceptionToThrow, msg);
        } break;
````

实际上的情况，传递的参数太多，这个理论上，不会存在，不过也应该进行检测，hook ServiceManager 相关的 binder 就可以了。更多的可能是 FD 被关闭了。例如一些 File 没有正常的关闭，后面才关闭。类似的情况.

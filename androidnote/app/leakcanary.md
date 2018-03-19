## LeakCanary 内存泄露检测

大致原理是，注册 registerActivityLifecycleCallbacks ，拿到 activity 的生命周期回调，然后在 onDestory 的时候，对这个 activity 保持弱引用，手动触发 GC ，看看这个弱引用还能拿到对象不。能拿到的话，再利用 haha 库来 dump head 内存。
## 记录一下 Android 基础而又容易忘记的知识点

    * 要想一个App，展示多个 Activity 在任务栏上
    添加 Intent.FLAG_ACTIVITY_NEW_DOCUMENT 和 Intent.FLAG_ACTIVITY_MULTIPLE_TASK)
    或者在 manifest 添加 android:documentLaunchMode 进入 属性 例如 always ,[Android training](https://developer.android.com/guide/components/recents.html?hl=zh-cn)
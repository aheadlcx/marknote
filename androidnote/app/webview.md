## WebView 优化

	* webview 标题，返回的时候，部分机型不会返回 title ，需要自行在加载完成里面，做兼容处理。
	* webview 资源，代理加载，和预加载。
	* WebView 初始化慢，就随时初始化好一个 WebView 待用。
	* webview 防劫持 参考 [美团的总结](https://tech.meituan.com/WebViewPerf.html)
	* Webview onPause 和 onResume
	* webview 在 5.0 之后，默认不支持 http https 混合问题 

	````java
	if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {  
webSetting.setMixedContentMode(webSetting.getMixedContentMode()); 
 }  
 ````

 	* 
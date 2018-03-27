## Bitmap 的内存占用大小

[参考链接](http://www.jcodecraeer.com/a/anzhuokaifa/androidkaifa/2016/0116/3874.html)

scaledWidth * scaledHeight  * 格式（一像素占用多少 byte)


targetDensity 就是当前设备的 density
density 是当前资源在什么资源目录下的 density
 scale = (float) targetDensity / density;

originWidth
   scaledWidth = int(originWidth * scale + 0.5f);




| density   | 1    | 1.5 | 2 | 3 | 3.5 | 4 |
| ----------|------|-----|---|---|-----|---|
| densityDpi|  160 |240  |320|480| 560 |640|

hdpi 为 240
xdpi = 320
xxhdpi 为480

不同图片格式占用的字节大小

````java
  static const uint8_t gSize[] = {
    0,  // Unknown
    1,  // Alpha_8
    2,  // RGB_565
    2,  // ARGB_4444
    4,  // RGBA_8888
    4,  // BGRA_8888
    1,  // kIndex_8
  };
````

### 问题

* 如果是网络图片呢
就是说 density 为0 的情况了。
BitmapFactory.Options  inDensity 有注解

````java
         * {@link BitmapFactory#decodeResource(Resources, int)}, 
         * {@link BitmapFactory#decodeResource(Resources, int, android.graphics.BitmapFactory.Options)},
         * and {@link BitmapFactory#decodeResourceStream}
         * will fill in the density associated with the resource.  The other
         * functions will leave it as-is and no density will be applied.
````

追踪一下代码，在 BitmapFactory.cpp 的 doDecode 方法中，发现 inDensity == 0 ,那么 scale 就是 1 了。

````java
    float scale = 1.0f;
            if (density != 0 && targetDensity != 0 && density != screenDensity) {
                scale = (float) targetDensity / density;
            }
````

# mpv-LoadingTips
十分简易的mpv lua插件，用于mpv加载文件时显示一个加载中提示

### 预览图片
![Snipaste_2025-03-08_05-50-11](https://github.com/user-attachments/assets/c4434fd5-a773-4a3e-82d6-dfbf7a78d143)
![Snipaste_2025-03-08_05-48-32](https://github.com/user-attachments/assets/ae3a4b37-abdf-4ec6-855e-9f8aae1f774e)

### 使用场景说明及演示
使用emby或者其他网络视频流场景调用mpv播放时总是会有漫长的等待时间，但是这个阶段是没有任何提示的，十分生硬像无响应一样，于是便有了这个脚本，由Claude所写（

https://github.com/user-attachments/assets/a98286c3-2f87-494a-aba8-462590010f49

## 特性
也支持切换播放列表时提示

只在加载文件阶段提示，一旦成功加载可以播放就不再提示（不影响播放本地文件并且智能消失）

提示文本缩放、位置自适应显示器分辨率

提示文本内容及位置可以随意自定义

## 使用说明
正常放入scripts文件夹即可

没有单独配置文件，但是代码只有70多行很容易修改

提示拥有60秒CD，用来防止一些脚本冲突导致重复提示，介意可自行修改关闭

一些程序调用MPV播放时如果不优先生成窗口，请在mpv.conf中添加
```
force-window=immediate                                       #（强制）创建视频输出窗口，即使没有视频输入
```

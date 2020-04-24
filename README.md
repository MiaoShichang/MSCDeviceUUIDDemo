# 简介 
MSCDeviceUUID 获取设备ID

注意事项：

1.此MSCDeviceUUID库中获取到的是一个伪设备uuid，是保存在keychain中，该uuid只对当前app有效，保证是唯一的，同一个设备不同的app获取到的设备uuid的值是不同的，使用时需谨慎。关于keychain相关信息请自行查询。

2.如果此MSCDeviceUUID有什么问题，欢迎留言。

# 安装方式

  在文件 `Podfile` 中加入以下内容：
 ```
 pod 'MSCDeviceUUID'
 ``` 
  然后在终端中运行以下命令：
 ```
 pod install
 ```

# 使用方式

  ```
  // 获取设备ID
  NSString *deviceUUID = [MSCDeviceUUID deviceUUID];
  NSLog(@"device uuid -- %@", deviceUUID);
  ```
  
  
  
  

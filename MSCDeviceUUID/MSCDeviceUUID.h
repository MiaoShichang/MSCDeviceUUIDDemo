//
//  MSCDeviceUUID.h
//  MSCDeviceUUIDDemo
//
//  Created by MiaoShichang on 15/10/29.
//  Copyright © 2015年 MiaoShichang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *@brief 该工具类创建的是一个伪设备UUID，只是把一个UUID保存到keychain，关于keychain的相关资料请自己查阅。
 *@note 1.如果想删除保存在keychain中的值，请调用.m文件中的 deleteUUID 方法
 *      2.使用时如果没有生成成功，请添加的库：Security.framework
 */

@interface MSCDeviceUUID : NSObject

/**
 *@brief 获取设备的UUID
 */
+ (NSString *)deviceUUID;

@end

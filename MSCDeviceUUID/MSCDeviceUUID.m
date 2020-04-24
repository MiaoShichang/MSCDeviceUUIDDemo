//
//  MSCDeviceUUID.m
//  MSCDeviceUUIDDemo
//
//  Created by MiaoShichang on 15/10/29.
//  Copyright © 2015年 MiaoShichang. All rights reserved.
//

#import "MSCDeviceUUID.h"
#import <Security/Security.h>

static NSString *const identifierForDeviceUUID = @"identifierForDeviceUUID201510";

@implementation MSCDeviceUUID

+ (NSString *)makeUUID {
    //also known as uuid/universallyUniqueIdentifier
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    
    NSString *uuidValue = CFBridgingRelease(uuidStringRef);
    uuidValue = [uuidValue lowercaseString];
    uuidValue = [uuidValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return uuidValue;
}

#pragma mark -- keychain
+ (NSMutableDictionary *)query {
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    [query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [query setObject:identifierForDeviceUUID forKey:(id)kSecAttrGeneric];
    [query setObject:identifierForDeviceUUID forKey:(id)kSecAttrAccount];
    [query setObject:identifierForDeviceUUID forKey:(id)kSecAttrDescription];
    [query setObject:identifierForDeviceUUID forKey:(id)kSecAttrLabel];
    [query setObject:identifierForDeviceUUID forKey:(id)kSecAttrComment];
    [query setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    [query setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
    [query setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    return query;
}

+ (NSMutableDictionary *)value:(NSString *)uuid {
    NSAssert((uuid != nil && uuid.length>0), @"the uuid is not legal in function value");
    if(uuid == nil){uuid = @"";}
    NSMutableDictionary *value = [NSMutableDictionary dictionary];
    [value setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [value setObject:identifierForDeviceUUID forKey:(id)kSecAttrGeneric];
    [value setObject:identifierForDeviceUUID forKey:(id)kSecAttrAccount];
    [value setObject:identifierForDeviceUUID forKey:(id)kSecAttrDescription];
    [value setObject:identifierForDeviceUUID forKey:(id)kSecAttrLabel];
    [value setObject:identifierForDeviceUUID forKey:(id)kSecAttrComment];
    [value setObject:[uuid dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
    return value;
}

//
+ (NSString *)deviceUUID {
    NSString *deviceUUID = nil;
    NSMutableDictionary *qurey = [self query];
    NSDictionary *tempQuery = [NSDictionary dictionaryWithDictionary:qurey];
    CFMutableDictionaryRef *outDictionary = nil;
    if (SecItemCopyMatching((CFDictionaryRef)tempQuery, (CFTypeRef *)&outDictionary) == noErr){
        NSDictionary *outValue = CFBridgingRelease(outDictionary);
        NSData *data = [outValue objectForKey:(id)kSecValueData];
        deviceUUID = [[NSString alloc] initWithBytes:[data bytes] length:[data length]
                                            encoding:NSUTF8StringEncoding];
    }
    else{
        deviceUUID = [self makeUUID];
        NSMutableDictionary *value = [self value:deviceUUID];
        OSStatus result = SecItemAdd((CFDictionaryRef)value, NULL);
        NSAssert( result == noErr, @"Couldn't add the Keychain Item." );
        if(result != noErr){
            deviceUUID = nil;
        }
    }
    
    return deviceUUID;
}

/**
 *@brief 此函数的作用是删除保存在keychain中的UUID
 */
+ (BOOL)deleteUUID {
    NSMutableDictionary *query = [self query];
    [query removeObjectForKey:(id)kSecMatchLimit];
    [query removeObjectForKey:(id)kSecReturnAttributes];
    [query removeObjectForKey:(id)kSecReturnData];
    
    NSDictionary *tempQuery = [NSDictionary dictionaryWithDictionary:query];
    CFMutableDictionaryRef *outDictionary = nil;
    if (SecItemCopyMatching((CFDictionaryRef)tempQuery, (CFTypeRef *)&outDictionary) == noErr){
        NSMutableDictionary *outDict = CFBridgingRelease(outDictionary);
        [outDict removeObjectForKey:(id)kSecAttrAccessControl];
        OSStatus junk = SecItemDelete((CFDictionaryRef)query);
        NSAssert( junk == noErr || junk == errSecItemNotFound, @"Problem deleting current dictionary." );
        if(junk == noErr || junk == errSecItemNotFound){
            return YES;
        }
        else{
            return NO;
        }
    }
    
    return YES;
}

@end

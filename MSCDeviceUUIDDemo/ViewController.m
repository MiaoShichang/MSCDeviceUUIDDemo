//
//  ViewController.m
//  MSCDeviceUUIDDemo
//
//  Created by MiaoShichang on 15/10/29.
//  Copyright © 2015年 MiaoShichang. All rights reserved.
//

#import "ViewController.h"
#import "MSCDeviceUUID.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 获取device uuid
    NSLog(@"device uuid -- %@", [MSCDeviceUUID deviceUUID]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

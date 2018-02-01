//
//  AppDelegate.h
//  SHSendMessage
//
//  Created by HaoSun on 2018/1/31.
//  Copyright © 2018年 YHKIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


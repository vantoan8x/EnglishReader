//
//  AppDelegate.h
//  GoSpeak
//
//  Created by Nguyen Van Toan on 05/05/2013.
//  Copyright (c) 2013 Horical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaveContent.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, assign) NSString *appPath;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *nav;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) SaveContent *saveContent;

@end

AppDelegate *appShare;
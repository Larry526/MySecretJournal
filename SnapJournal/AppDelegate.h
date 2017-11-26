//
//  AppDelegate.h
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-25.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


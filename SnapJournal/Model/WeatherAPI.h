//
//  WeatherAPI.h
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-28.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherAPI : NSObject

+ (void)searchLat:(NSString*)lat Lon:(NSString*)lon complete:(void (^)(NSDictionary *results))done;

@end

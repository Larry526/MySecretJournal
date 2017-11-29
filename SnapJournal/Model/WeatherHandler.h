//
//  WeatherHandler.h
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-29.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherHandler : NSObject

-(NSString*)getWeatherIcon:(NSInteger)conditionID;


@end

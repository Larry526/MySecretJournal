//
//  WeatherHandler.m
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-29.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "WeatherHandler.h"

@interface WeatherHandler()


@end


@implementation WeatherHandler

-(NSString *)getWeatherIcon:(NSInteger)conditionID {
    
    switch (conditionID) {
        case 200 ... 232 :
            return @"tstorm";
            break;
            
        case 300 ... 321 :
            return @"lightrain";
            break;

        case 501 ... 531 :
            return @"shower";
            break;

        case 600 ... 622 :
        case 903 :
            return @"snow";
            break;

        case 701 ... 781 :
            return @"fog";
            break;

        case 801 ... 803 :
            return @"cloudy";
            
        case 804:
            return @"overcast";
            break;
            
        case 800 :
        case 904 :
            return @"sunny";
            
        case 901 ... 902:
        case 905 ... 1000 :
            return @"tstorm2";
            break;
            
        default:
            return @"na";
            break;
    }
}

@end

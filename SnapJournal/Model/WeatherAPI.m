//
//  WeatherAPI.m
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-28.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "WeatherAPI.h"

@implementation WeatherAPI


+(void)searchLat:(NSString *)lat Lon:(NSString *)lon complete:(void (^)(NSDictionary *))done{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&appid=e72ca729af228beabd5d20e3b7749713", lat, lon]];
    NSURLSessionTask *task =
    [[NSURLSession sharedSession]
     dataTaskWithURL:url
     completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
         // begin standard error handling
         if (error != nil) {
             NSLog(@"Error while making request: %@", error.localizedDescription);
             abort();
         }
         NSHTTPURLResponse *resp = (NSHTTPURLResponse*)response;
         if (resp.statusCode > 299) {
             NSLog(@"Bad status code: %ld", resp.statusCode);
             abort();
         }
         // end standard error handling
         
         // parse response
         NSError *err = nil;
         NSDictionary *result = [NSJSONSerialization
                                 JSONObjectWithData:data
                                 options:0
                                 error:&err];
         if (err != nil) {
             NSLog(@"Something has gone wrong parsing JSON: %@", err.localizedDescription);
             abort();
         }
         
      
         done(result);
     }];
    
    [task resume];
}

@end

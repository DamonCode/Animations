//
//  FlightData.h
//  Flight Info
//
//  Created by Damon on 2016/11/16.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlightData : NSObject

@property (copy, nonatomic) NSString *summary, *flightNr, *gateNr, *departingFrom, *arrivingTo, *weatherImageName, *flightStatus;
@property (assign, nonatomic) BOOL isTakingOff, showWeatherEffects;


@end

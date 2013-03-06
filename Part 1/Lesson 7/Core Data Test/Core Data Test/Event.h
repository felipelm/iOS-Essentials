//
//  Event.h
//  Core Data Test
//
//  Created by Felipe on 1/14/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventData;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) EventData *eventData;

@end

//
//  EventData.h
//  Core Data Test
//
//  Created by Felipe on 1/14/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface EventData : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Event *event;

@end

//
//  ShownActivity.m
//  ShangPin
//
//  Created by 唐彬琪 on 11-8-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ShownActivity.h"


@implementation ShownActivity
@synthesize activityID;
@synthesize activityNO;
@synthesize time;
@synthesize pic;


- (void)dealloc
{
    [activityID release];
    [activityNO release];
    [time release];
    [pic release];
    [super dealloc];
}

@end

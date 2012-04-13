//
//  SuperAct.m
//  ShangPin
//
//  Created by 唐彬琪 on 11-8-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SuperAct.h"


@implementation SuperAct
@synthesize Name;
@synthesize ID;
@synthesize bigImage;

- (void)dealloc
{
    [Name release];
    [ID release];
    [bigImage release];
    [super dealloc];
}

@end

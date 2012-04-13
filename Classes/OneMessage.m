//
//  OneMessage.m
//  ShangPin
//
//  Created by 唐彬琪 on 11-8-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "OneMessage.h"


@implementation OneMessage
@synthesize message;
@synthesize Date;
@synthesize isme;

-(void)dealloc{
    [message release];
    [Date release];
    [super dealloc];
    
}

@end

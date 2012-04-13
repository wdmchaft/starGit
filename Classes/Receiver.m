//
//  Receiver.m
//  ShangPin
//
//  Created by ch_int_beam on 11-3-9.
//  Copyright 2011 Beyond. All rights reserved.
//

#import "Receiver.h"


@implementation Receiver
@synthesize isdefault;


- (void)dealloc
{
	[isdefault release];
	[super dealloc];
}
@end

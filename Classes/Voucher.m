//
//  Voucher.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Voucher.h"


@implementation Voucher

@synthesize Type;
@synthesize Name;
@synthesize Date;
@synthesize isvalid;

-(void) dealloc
{
	[Type release];
	[Name release];
	[Date release];
	[isvalid release];
	[super dealloc];
}

@end

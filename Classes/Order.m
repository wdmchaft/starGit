//
//  Order.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Order.h"


@implementation Order
@synthesize orderid;
@synthesize orderstate;
@synthesize goodsArray;

-(void) dealloc
{
	[orderid release];
	[orderstate release];
	[goodsArray release];
	[super dealloc];
}


@end

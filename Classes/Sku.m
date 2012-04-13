//
//  Sku.m
//  ShangPin
//
//  Created by apple_cyy on 11-3-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sku.h"


@implementation Sku

@synthesize skuNo;
@synthesize color;
@synthesize size;
@synthesize quantity;
@synthesize level;
@synthesize limitedprice;
@synthesize image;
@synthesize bigimg;

-(void) dealloc
{
	[skuNo release];
	[color release];
	[size release];
	[quantity release];
	[level release];
	[limitedprice release];
	[image release];
	[bigimg release];
	[super dealloc];
}

@end

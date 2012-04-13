//
//  Address.m
//  ShangPin
//
//  Created by apple_cyy on 11-3-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Address.h"


@implementation Address
@synthesize Name;
@synthesize city;
@synthesize address;
@synthesize postcode;
@synthesize phone;
@synthesize mobile;
@synthesize consigneeid;


-(void) dealloc
{
	[Name release];
	[city release];
	[address release];
	[postcode release];
	[phone release];
	[mobile release];
	[consigneeid release];
	[super dealloc];
}

@end

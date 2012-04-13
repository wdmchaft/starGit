//
//  Willsale.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Willsale.h"


//@implementation Willsale
//@synthesize ID;
//@synthesize Name;
//@synthesize img;
//
//
//-(void) dealloc
//{
//	[ID release];
//	[Name release];
//	[img release];
//	[super dealloc];
//}
//
//
//@end


@implementation Willsale
@synthesize ID;
@synthesize title;
@synthesize date;
@synthesize Name;
@synthesize img;
@synthesize text;


-(void) dealloc
{
	[ID release];
    [title release];
    [date release];
	[Name release];
	[img release];
    [text release];
	[super dealloc];
}

@end

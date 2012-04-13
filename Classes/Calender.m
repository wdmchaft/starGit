//
//  Calender.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Calender.h"


@implementation Calender
@synthesize date;
@synthesize hot;



-(void) dealloc
{
	[date release];
	[hot release];
	[super dealloc];
}


@end


//@implementation Calender
//@synthesize ID;
//@synthesize BrandName;
//@synthesize Time;
//@synthesize Name;
//@synthesize img;
//
//
//-(void) dealloc
//{
//	[ID release];
//    [BrandName release];
//    [Time release];
//	[Name release];
//	[img release];
//	[super dealloc];
//}
//
//@end

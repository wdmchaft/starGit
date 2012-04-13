//
//  DB.m
//  ShangPin
//
//  Created by apple_cyy on 11-3-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DB.h"


@implementation DB

static sqlite3 * dbPointer;

+(sqlite3 *) openDB		//打开存放于 bundle中名字为area.sqlite数据库
{
	if(dbPointer)
	{
		return dbPointer;
	}
	NSString *orignPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"sqlite"];
	sqlite3_open([orignPath UTF8String], &dbPointer);
	return dbPointer;
}

+(void) closeDB
{
	if(dbPointer)
	{
		sqlite3_close(dbPointer);
		dbPointer = nil;
	}
}


@end

//
//  DB.h
//  ShangPin
//
//  Created by apple_cyy on 11-3-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 数据库 相关
 1、打开 省市区 数据库
 2、关闭 省市区 数据库
 */

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DB : NSObject 

+(sqlite3 *) openDB;		//打开数据库
+(void) closeDB;			//关闭数据库

@end

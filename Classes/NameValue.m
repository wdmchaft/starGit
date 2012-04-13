//
//  NameValue.m
//  ShangPin
//
//  Created by apple_cyy on 11-3-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NameValue.h"
#import "DB.h"

@implementation NameValue
@synthesize name;
@synthesize value;

-(NameValue *) initWithId:(int) theId andName:(NSString *)theName
{
	if(self = [super init])
	{
		value = theId;
		self.name = theName;
	}
	return self;
}

+(NSMutableArray *)finaAllProvince		//查询全部省份
{
	sqlite3 *db = [DB openDB];
	sqlite3_stmt *stmt;
	int result = sqlite3_prepare_v2(db, "select * from Province order by ProvinceId", -1, &stmt, nil);
	if(result == SQLITE_OK)
	{
		NSMutableArray *provinceArray = [[NSMutableArray alloc] init];
		while(SQLITE_ROW == sqlite3_step(stmt))
		{
			int provinceId = sqlite3_column_int(stmt, 0);
			const unsigned char *provinceName = sqlite3_column_text(stmt, 1);
			NameValue *province = [[NameValue alloc] initWithId:provinceId andName:[NSString stringWithUTF8String:(const char *)provinceName]];
			[provinceArray addObject:province];
			[province release];
		}
		sqlite3_finalize(stmt);
		return [provinceArray autorelease];
	}
	else
	{
		NSLog(@"查询失败:%d",result);
		sqlite3_finalize(stmt);
		return [NSMutableArray array];
	}
}

+(NSMutableArray *) finaAllCityFromProvinceValue:(int) theProvinceValue		//查询 某省份下的 全部城市
{
	sqlite3 *db = [DB openDB];
	sqlite3_stmt *stmt;
	int result = sqlite3_prepare_v2(db, "select * from City where ProvinceId = ? order by CityId", -1, &stmt, nil);
	if(result == SQLITE_OK)
	{
		sqlite3_bind_int(stmt, 1, theProvinceValue);
		NSMutableArray *cityArray = [[NSMutableArray alloc] init];
		while(SQLITE_ROW == sqlite3_step(stmt))
		{
			int cityId = sqlite3_column_int(stmt, 0);
			const unsigned char *cityName = sqlite3_column_text(stmt, 2);
			NameValue *city = [[NameValue alloc] initWithId:cityId andName:[NSString stringWithUTF8String:(const char *)cityName]];
			[cityArray addObject:city];
			[city release];
		}
		sqlite3_finalize(stmt);
		return [cityArray autorelease];
	}
	else
	{
		NSLog(@"查询失败:%d",result);
		sqlite3_finalize(stmt);
		return [NSMutableArray array];
	}
}

+(NSMutableArray *) finaAllAreaFromCityValue:(int) theCityValue		//查询 某城市下的 全部地区
{
	sqlite3 *db = [DB openDB];
	sqlite3_stmt *stmt;
	int result = sqlite3_prepare_v2(db, "select * from Area where CityId = ? order by AreaId", -1, &stmt, nil);
	if(result == SQLITE_OK)
	{
		sqlite3_bind_int(stmt, 1, theCityValue);
		NSMutableArray *areaArray = [[NSMutableArray alloc] init];
		while(SQLITE_ROW == sqlite3_step(stmt))
		{
			int areaId = sqlite3_column_int(stmt, 0);
			const unsigned char *areaName = sqlite3_column_text(stmt, 2);
			NameValue *area = [[NameValue alloc] initWithId:areaId andName:[NSString stringWithUTF8String:(const char *)areaName]];
			[areaArray addObject:area];
			[area release];
		}
		sqlite3_finalize(stmt);
		return [areaArray autorelease];
	}
	else
	{
		NSLog(@"查询失败:%d",result);
		sqlite3_finalize(stmt);
		return [NSMutableArray array];
	}
	
}

+(NSString *)findAddressWithValue:(NSString *)value		//根据value查看name 例如：传入1-1-1 得到：北京 北京市 海淀区
{
	NSArray *array = [value componentsSeparatedByString:@"-"];
	int provinceId = [[array objectAtIndex:0] intValue];
	int cityId = [[array objectAtIndex:1] intValue];
	int areaId = [[array objectAtIndex:2] intValue];
	NSString *province = [self findProvinceFromValue:provinceId];
	NSString *city = [self findCityFromValue:cityId];
	NSString *area = [self findAreaFromValue:areaId];
	return [NSString stringWithFormat:@"%@ %@ %@",province,city,area];
	
}

+(NSString *)findProvinceFromValue:(int) provinceValue	//根据 省份value 获得 省份名称
{
	sqlite3 *db = [DB openDB];
	sqlite3_stmt *stmt;
	NSLog(@"provinceId = %d",provinceValue);
	int result = sqlite3_prepare_v2(db, "select * from Province where ProvinceId = ? limit 1", -1, &stmt, nil);
	if(result == SQLITE_OK)
	{
		sqlite3_bind_int(stmt, 1, provinceValue);
		if(SQLITE_ROW == sqlite3_step(stmt))
		{
			const unsigned char *provinceName = sqlite3_column_text(stmt, 1);
			NSString *province = [NSString stringWithUTF8String:(const char*)provinceName];
			sqlite3_finalize(stmt);
			return province;
		}
		else
		{
			sqlite3_finalize(stmt);
			return @"";
		}
	}
	else
	{
		sqlite3_finalize(stmt);
		NSLog(@"查询的时候出现了错误");
		return @"";
	}
}


+(NSString *)findCityFromValue:(int) cityValue		//根据 城市value 获得 城市name
{
	sqlite3 *db = [DB openDB];
	sqlite3_stmt *stmt;
	int result = sqlite3_prepare_v2(db, "select * from City where CityId = ? limit 1", -1, &stmt, nil);
	if(result == SQLITE_OK)
	{
		sqlite3_bind_int(stmt, 1, cityValue);
		if(SQLITE_ROW == sqlite3_step(stmt))
		{
			const unsigned char *cityName = sqlite3_column_text(stmt, 2);
			NSString *city = [NSString stringWithUTF8String:(const char*)cityName];
			sqlite3_finalize(stmt);
			return city;
		}
		else
		{
			sqlite3_finalize(stmt);
			return @"";
		}
	}
	else
	{
		NSLog(@"查询的时候出现了错误");
		sqlite3_finalize(stmt);
		return @"";
	}
}

+(NSString *)findAreaFromValue:(int) areaValue		//根据 地区value 获得 地区name
{
	sqlite3 *db = [DB openDB];
	sqlite3_stmt *stmt;
	int result = sqlite3_prepare_v2(db, "select * from Area where AreaId = ? limit 1", -1, &stmt, nil);
	if(result == SQLITE_OK)
	{
		sqlite3_bind_int(stmt, 1, areaValue);
		if(SQLITE_ROW == sqlite3_step(stmt))
		{
			const unsigned char *areaName = sqlite3_column_text(stmt, 2);
			NSString *area = [NSString stringWithUTF8String:(const char*)areaName];
			sqlite3_finalize(stmt);
			return area;
		}
		else
		{
			sqlite3_finalize(stmt);
			return @"";
		}
	}
	else
	{
		NSLog(@"查询的时候出现了错误");
		sqlite3_finalize(stmt);
		return @"";
	}
}

+(int)findProvinceValueFromName:(NSString *)theName	//根据 省份的name 获得 省份value
{
	sqlite3 *db = [DB openDB];
	sqlite3_stmt *stmt;
	NSLog(@"provinceId = %@",theName);
	int result = sqlite3_prepare_v2(db, "select * from Province where ProvinceName = ? limit 1", -1, &stmt, nil);
	if(result == SQLITE_OK)
	{
		sqlite3_bind_text(stmt, 1, [theName UTF8String], -1, NULL);
		if(SQLITE_ROW == sqlite3_step(stmt))
		{
			int provinceID = sqlite3_column_int(stmt, 0);
			sqlite3_finalize(stmt);
			return provinceID;
		}
		else
		{
			sqlite3_finalize(stmt);
			return 1;
		}
	}
	else
	{
		NSLog(@"查询的时候出现了错误");
		sqlite3_finalize(stmt);
		return 1;
	}
}

+(int)findCityValueFromName:(NSString *)theName		//根据 城市的name 获得 城市value
{
	sqlite3 *db = [DB openDB];
	sqlite3_stmt *stmt;
	int result = sqlite3_prepare_v2(db, "select * from City where CityName = ? limit 1", -1, &stmt, nil);
	if(result == SQLITE_OK)
	{
		sqlite3_bind_text(stmt, 1, [theName UTF8String], -1, NULL);
		if(SQLITE_ROW == sqlite3_step(stmt))
		{
			int cityID = sqlite3_column_int(stmt, 0);
			sqlite3_finalize(stmt);
			return cityID;
		}
		else
		{
			sqlite3_finalize(stmt);
			return 1;
		}
	}
	else
	{
		NSLog(@"查询的时候出现了错误");
		sqlite3_finalize(stmt);
		return 1;
	}
	
}

+(int)findAreaValueFromName:(NSString *)theName		//根据 地区的name 获得 地区value
{
	sqlite3 *db = [DB openDB];
	sqlite3_stmt *stmt;
	int result = sqlite3_prepare_v2(db, "select * from Area where AreaName = ? limit 1", -1, &stmt, nil);
	if(result == SQLITE_OK)
	{
		sqlite3_bind_text(stmt, 1, [theName UTF8String], -1, NULL);
		if(SQLITE_ROW == sqlite3_step(stmt))
		{
			int areaID = sqlite3_column_int(stmt, 0);
			sqlite3_finalize(stmt);
			return areaID;
		}
		else
		{
			sqlite3_finalize(stmt);
			return 1;
		}
	}
	else
	{
		NSLog(@"查询的时候出现了错误");
		sqlite3_finalize(stmt);
		return 1;
	}
	
}


-(void) dealloc
{
	[name release];
	[super dealloc];
}

@end

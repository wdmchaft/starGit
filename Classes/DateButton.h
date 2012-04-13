//
//  DateButton.h
//  TestCalender
//
//  Created by cyy on 11-3-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 自定义按钮
 
 预售日历需要用到此类
 */

#import <UIKit/UIKit.h>


@interface DateButton : UIButton
{
	NSString *dateStr;			//日期
	NSString *flag;				//1-尚品一小时 0-一般预售
	UIImageView *pointImgV;		//flag为1时，显示图片
}

@property(nonatomic,copy) NSString *dateStr;
@property(nonatomic,copy) NSString *flag;

-(id) initWithFrame:(CGRect)theFrame dateStr:(NSString *)theDateStr andFlag:(NSString *)theFlag;

@end

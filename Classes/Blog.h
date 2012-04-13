//
//  Blog.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 博客列表里每条博客包含的信息
 
 包含4部分 
 1、博客id
 2、博客标题
 3、博客时间
 4、博客内容简介
 */

#import <Foundation/Foundation.h>

@interface Blog : NSObject 
{
	NSString *ID;
	NSString *title;
	NSString *time;
	NSString *content;
}

@property(nonatomic, copy) NSString *ID;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, copy) NSString *content;

@end

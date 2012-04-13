//
//  CustomLabel.h
//  PingAn
//
//  Created by apple_cyy on 10-12-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/*
 自定义Label,添加了垂直对齐功能
 */


#import <Foundation/Foundation.h>

typedef enum
{
	VerticalAlignmentTop = 0, // default
	VerticalAlignmentMiddle,
	VerticalAlignmentBottom,
} VerticalAlignment;


/*
 自定义UILabel，添加了垂直对齐方式。
 */
@interface CustomLabel : UILabel
{
	
@private 
	/*
	 声明一个枚举类型 变量， 用来记录垂直对齐方式。
	 */
	VerticalAlignment _verticalAlignment; 
	
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end

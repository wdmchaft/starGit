//
//  CustomImageView.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 九宫格 自定义图片
 */

#import <UIKit/UIKit.h>


@protocol CustomImageViewDelegate;

@interface CustomImageView : UIImageView 
{
	id<CustomImageViewDelegate> delegate;		//代理方法，捕获点击事件
	NSString *productNO;						//商品id
	NSString *catalogNO;						//分类id
	NSString *Name;								//商品名称
}

@property(nonatomic,assign) id<CustomImageViewDelegate> delegate;
@property(nonatomic,copy) NSString *productNO;
@property(nonatomic,copy) NSString *catalogNO;
@property(nonatomic,copy) NSString *Name;

@end


@protocol CustomImageViewDelegate

-(void) customImageViewPressed:(CustomImageView *)customImgV;

@end
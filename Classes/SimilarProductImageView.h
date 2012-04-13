//
//  SimilarProductImageView.h
//  ShangPin
//
//  Created by cyy on 11-3-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 自定义的UIImageView
 
 
 添加了一些属性，用于向链接中传参
 
 添加了点击事件，商品详情中用到了。
 点击同类商品，显示点击商品的相关信息。
 */
#import <UIKit/UIKit.h>

@protocol SimilarProductDelegate		//代理 用来响应点击事件 显示点击商品的相关信息

-(void) didTouchEndSimilarProduct:(id) similarProduct;

@end


@interface SimilarProductImageView : UIImageView 
{
	id<SimilarProductDelegate> delegate;
	NSString *catNo;			//活动编号
	NSString *productNo;		//产品编号
	NSString *img;				//图片地址
}

@property(nonatomic,assign) id<SimilarProductDelegate> delegate;
@property(nonatomic,copy) NSString *catNo;
@property(nonatomic,copy) NSString *productNo;
@property(nonatomic,copy) NSString *img;

@end

//
//  LoadingView.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


/*
 等待界面
 
 上面一个黑色背景
 一个风火轮
 一个label
 
 请求数据的时候都要用到这个
 */

#import <UIKit/UIKit.h>

@interface LoadingView : UIView 
{
	UILabel *waitLabel;							//文字描述
	UIActivityIndicatorView *activityV;			//风火轮
}

@property(nonatomic, retain)UIActivityIndicatorView * activityV;
-(void) finishLoading;

@end

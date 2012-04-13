//
//  BlogDetailViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 博客详情 视图控制器
 
 对应界面 尚品资讯－详情
 */

#import <UIKit/UIKit.h>


@interface BlogDetailViewController : UIViewController <UIWebViewDelegate>
{
	UILabel *titleLabel;						//标题
	UILabel *timeLabel;							//时间
	UIWebView *contentView;						//内容
	
	LoadingView *loadingView;					//等待界面
	NSURLConnection *detailConnection;			//博客详情 链接
	NSMutableData *receivedData;				//接口返回的数据
}

@property(nonatomic, retain) NSMutableData *receivedData;

-(void) blogDetailContent:(NSString *) theID;


@end

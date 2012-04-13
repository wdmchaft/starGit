//
//  MyOrderViewController.h
//  ShangPin
//
//  Created by tang binqi on 12-2-12.
//  Copyright (c) 2012年 shangpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderView.h"

@interface MyOrderViewController : UIViewController<MyOrderDelegate,MyOrderDetailDelegate>
{
    MyOrderView *  myOrderView;
    MyOrderDetailViewController * orderDetailVC;        
}
@property (nonatomic , retain) MyOrderView *  myOrderView;

@end

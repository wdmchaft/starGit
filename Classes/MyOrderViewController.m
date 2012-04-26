//
//  MyOrderViewController.m
//  ShangPin
//
//  Created by tang binqi on 12-2-12.
//  Copyright (c) 2012年 shangpin. All rights reserved.
//

#import "MyOrderViewController.h"

@implementation MyOrderViewController
@synthesize myOrderView;

#pragma mark -
#pragma mark 返回 我的账户界面
- (void)returnBack
{
	[self.navigationController popViewControllerAnimated:YES];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //返回按钮
        self.title = @"我的订单";
//        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        backButton.frame = CGRectMake(0, 0, 53, 29);
//        backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [backButton setTitle:@" 返回" forState:UIControlStateNormal];
//        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//        [backButton setBackgroundImage:[UIImage imageNamed:@"BackAll.png"] forState:UIControlStateNormal];
//        [backButton addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//        self.navigationItem.leftBarButtonItem = backItem;
//        [backItem release];

        UIBarButtonItem *backBI = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(returnBack)];
        self.navigationItem.leftBarButtonItem = backBI;
        [backBI release];

        
        myOrderView = [[MyOrderView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStylePlain];
		myOrderView.dataSource = myOrderView;
		myOrderView.delegate = myOrderView;
		myOrderView.orderDelegate = self;
		[self.view addSubview:myOrderView];
        [myOrderView loadMyOrder];
        [myOrderView release];

    }
    return self;
}

#pragma mark -
#pragma mark MyOrderDelegate
-(void) showDetailOrder:(NSString *)orderId
{
	if(orderDetailVC == nil)
	{
		orderDetailVC = [[MyOrderDetailViewController alloc] init];
		orderDetailVC.delegate = self;
	}
	[self.navigationController pushViewController:orderDetailVC animated:YES];
	[orderDetailVC loadOrderDetail:orderId];
}

-(void) finishCancelOrder
{
	[self.myOrderView loadMyOrder];
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    myOrderView = nil;
    [orderDetailVC release];
    orderDetailVC = nil;
    [super dealloc];
}

@end

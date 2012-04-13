//
//  ServiceVC.m
//  ShangPin
//
//  Created by 唐彬琪 on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ServiceVC.h"


@implementation ServiceVC


- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MoreBackGround.png"]];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    titleLabel.center = CGPointMake(160, titleLabel.center.y);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"服务承诺";
    titleLabel.textColor = [UIColor colorWithRed:0.894f green:0.753f blue:0.373f alpha:1.0f];
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];

//    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];                //返回按钮
//    backButton.frame = CGRectMake(10, 7, 50, 30);
//    [backButton setBackgroundImage:[UIImage imageNamed:@"BackAll.png"] forState:UIControlStateNormal];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
//    backButton.showsTouchWhenHighlighted = YES;
//    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * leftNavigationButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = leftNavigationButton;
//    [leftNavigationButton release];

    UIBarButtonItem *backBI = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton)];
    self.navigationItem.leftBarButtonItem = backBI;
    [backBI release];

    
    UITextView * serviceTextView = [[UITextView alloc] init];
    serviceTextView.backgroundColor = [UIColor colorWithRed:0.439f green:0.439f blue:0.439f alpha:0.3f];
    serviceTextView.editable = NO;
    serviceTextView.showsVerticalScrollIndicator = NO;
    serviceTextView.textColor = [UIColor whiteColor];
    serviceTextView.layer.masksToBounds = YES;
    serviceTextView.layer.cornerRadius = 6.0f;
    serviceTextView.layer.borderWidth = 1.0f;
    serviceTextView.layer.borderColor = [[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f] CGColor];
    serviceTextView.text = SERVICE;
    serviceTextView.frame = CGRectMake(10, 10, 300, 340);
    [self.view addSubview:serviceTextView];
    [serviceTextView release];
     
    UIImageView * titleImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Service_round.png"]];
    titleImageView1.frame = CGRectMake(1, 1, 298, 29);
    [serviceTextView addSubview:titleImageView1];
    UILabel * partLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(1, 1, 298, 29)];
    partLabel1.backgroundColor = [UIColor clearColor];
    partLabel1.text = @"  S：尚品正品保证";
    //partLabel1.textColor = [UIColor colorWithRed:0.851f green:0.718f blue:0.353f alpha:1.0f];
    partLabel1.layer.masksToBounds = YES;
    partLabel1.layer.cornerRadius = 6.0f;
    //测试label的高亮属性
    partLabel1.highlighted = YES;
    partLabel1.highlightedTextColor = [UIColor colorWithRed:0.851f green:0.718f blue:0.353f alpha:1.0f];
    [serviceTextView addSubview:partLabel1];
    [partLabel1 release];
    [titleImageView1 release];

    UIImageView * titleImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Service_zhijiao.png"]];
    titleImageView2.frame = CGRectMake(1, 105, 298, 29);
    [serviceTextView addSubview:titleImageView2];
    UILabel * partLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(1, 105, 298, 29)];
    partLabel2.backgroundColor = [UIColor clearColor];
    partLabel2.text = @"  S：尚品大陆地区配送免运费";
    partLabel2.textColor = [UIColor colorWithRed:0.851f green:0.718f blue:0.353f alpha:1.0f];
    partLabel2.layer.masksToBounds = YES;
    partLabel2.layer.cornerRadius = 6.0f;
    [serviceTextView addSubview:partLabel2];
    [partLabel2 release];
    [titleImageView2 release];

    UIImageView * titleImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Service_zhijiao.png"]];
    titleImageView3.frame = CGRectMake(1, 210, 298, 29);
    [serviceTextView addSubview:titleImageView3];    
    UILabel * partLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(1, 210, 298, 29)];
    partLabel3.backgroundColor = [UIColor clearColor];
    partLabel3.text = @"  S：尚品支付方式";
    partLabel3.textColor = [UIColor colorWithRed:0.851f green:0.718f blue:0.353f alpha:1.0f];
    partLabel3.layer.masksToBounds = YES;
    partLabel3.layer.cornerRadius = 6.0f;
    [serviceTextView addSubview:partLabel3];
    [partLabel3 release];
    [titleImageView3 release];

    UIImageView * titleImageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Service_zhijiao.png"]];
    titleImageView4.frame = CGRectMake(1, 313, 298, 29);
    [serviceTextView addSubview:titleImageView4];
    UILabel * partLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(1, 313, 298, 29)];
    partLabel4.backgroundColor = [UIColor clearColor];
    partLabel4.text = @"  S：尚品退换货";
    partLabel4.textColor = [UIColor colorWithRed:0.851f green:0.718f blue:0.353f alpha:1.0f];
    partLabel4.layer.masksToBounds = YES;
    partLabel4.layer.cornerRadius = 6.0f;
    [serviceTextView addSubview:partLabel4];
    [partLabel4 release];
    [titleImageView4 release];

    UIImageView * titleImageView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Service_zhijiao.png"]];
    titleImageView5.frame = CGRectMake(1, 450, 298, 29);
    [serviceTextView addSubview:titleImageView5];
    UILabel * partLabel5 = [[UILabel alloc]initWithFrame:CGRectMake(1, 450, 298, 29)];
    partLabel5.backgroundColor = [UIColor clearColor];
    partLabel5.text = @"  S：尚品客服热线";
    partLabel5.textColor = [UIColor colorWithRed:0.851f green:0.718f blue:0.353f alpha:1.0f];
    partLabel5.layer.masksToBounds = YES;
    partLabel5.layer.cornerRadius = 6.0f;
    [serviceTextView addSubview:partLabel5];
    [partLabel5 release];
    [titleImageView5 release];


}

-(void)backButton{
    [self.navigationController popViewControllerAnimated:YES];
    
}

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

@end

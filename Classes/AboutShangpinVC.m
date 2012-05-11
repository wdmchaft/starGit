//
//  AboutShangpinVC.m
//  ShangPin
//
//  Created by 唐彬琪 on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AboutShangpinVC.h"


@implementation AboutShangpinVC


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
    titleLabel.text = @"关于尚品";
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
    
    
    UIScrollView * backScrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 440)];
    backScrView.backgroundColor = [UIColor clearColor];//colorWithPatternImage:image_cen];
    backScrView.contentSize = CGSizeMake(320, 481);
    backScrView.showsVerticalScrollIndicator = NO;
    //backScrView.delegate = self;

    
    UIImageView * rectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 10, 298, 376)];
    UIImage * aboutImage = [[UIImage imageNamed:@"AboutS.png"]stretchableImageWithLeftCapWidth:0.0f topCapHeight:14.0f];
    rectImageView.image = aboutImage;
    //加圆角
    rectImageView.layer.masksToBounds = YES;        //允许圆角
    rectImageView.layer.cornerRadius = 6.0f;       //圆角半径
    //rectImageView.layer.borderWidth = 1.0;          //边框宽度
    //rectImageView.layer.borderColor = [[UIColor yellowColor] CGColor];
    //添加阴影
    //rectImageView.layer.shadowOffset = CGSizeMake(0, -8);
    //rectImageView.layer.shadowRadius = 3.0f;
    //rectImageView.layer.shadowOpacity = 0.3;
    //rectImageView.layer.shadowColor = [[UIColor redColor]CGColor];
    
    UIImageView * shangpinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 263, 48)];
    shangpinImageView.image = [UIImage imageNamed:@"About_logo.png"];
    [rectImageView addSubview:shangpinImageView];
    [shangpinImageView release];
    
    UILabel * versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 200, 20)];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.text = @"版本 : 尚品网 v2.0";
    versionLabel.font = [UIFont systemFontOfSize:10.0f];
    versionLabel.textColor = [UIColor whiteColor];
    [rectImageView addSubview: versionLabel];
    [versionLabel release];
    
    
    UILabel * companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 200, 20)];
    companyLabel.backgroundColor = [UIColor clearColor];
    companyLabel.text = @"百姿网(北京)电子商务有限公司";
    companyLabel.font = [UIFont systemFontOfSize:12.0f];
    companyLabel.textColor = [UIColor whiteColor];
    [rectImageView addSubview:companyLabel];
    [companyLabel release];
    
    
    
    UIImageView * titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 110, 296, 29)];
    titleImageView.image = [UIImage imageNamed:@"CompanyProfile.png"];
    [rectImageView addSubview:titleImageView];
    [titleImageView release];
    
    UITextView * contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 150, 280, 216)];
    contentTextView.backgroundColor = [UIColor clearColor];
    contentTextView.editable = NO;
    contentTextView.text = OUTLINE;
    contentTextView.font = [UIFont systemFontOfSize:14.0f];
    contentTextView.textColor = [UIColor whiteColor];
    [rectImageView addSubview:contentTextView];
    [contentTextView release];
    
    [self.view addSubview:backScrView];
    [backScrView release];

    [backScrView addSubview:rectImageView];
    [rectImageView release];

    
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

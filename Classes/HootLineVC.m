//
//  HootLine.m
//  ShangPin
//
//  Created by 唐彬琪 on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "HootLineVC.h"


@implementation HootLineVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    titleLabel.center = CGPointMake(160, titleLabel.center.y);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"客服热线";
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

    
    UIView * aboutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    aboutView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MoreBackGround.png"]];
    
    UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    titleLable.font = [UIFont boldSystemFontOfSize:16];
    //titleLable.textColor = [UIColor clearColor];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text = @"尚品咨询 / 电话订购专线";
    titleLable.textAlignment = UITextAlignmentCenter;
    [aboutView addSubview:titleLable];
    [titleLable release];
    //titleLable.center = CGPointMake(160, 64);
    
    
    //电话按钮的背景
    UIImageView * rectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 54, 300, 280)];
    UIImage * hootTellImage = [[UIImage imageNamed:@"Layer_DownRound.png"]stretchableImageWithLeftCapWidth:0.0f topCapHeight:2.0f];
    rectImageView.image = hootTellImage;
    //加圆角
    rectImageView.layer.masksToBounds = YES;        //允许圆角
    rectImageView.layer.cornerRadius = 3.0f;       //圆角半径
     
    //添加阴影
    rectImageView.layer.shadowOffset = CGSizeMake(0, -8);
    rectImageView.layer.shadowRadius = 3.0f;
    [aboutView addSubview:rectImageView];
    [rectImageView release];
    
    UILabel * titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 270, 15)];
    titleLable1.font = [UIFont systemFontOfSize:13];
    //titleLable1.numberOfLines = 2;
    titleLable1.textColor = [UIColor whiteColor];
    titleLable1.backgroundColor = [UIColor clearColor];
    titleLable1.text = @"仅需支付市话费用,专享尚品VIP服务";
    [rectImageView addSubview:titleLable1];
    [titleLable1 release];
    
    UILabel * titleLable2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 270, 15)];
    titleLable2.font = [UIFont systemFontOfSize:13];
    titleLable2.textColor = [UIColor whiteColor];
    titleLable2.backgroundColor = [UIColor clearColor];
    titleLable2.text = @"周一至周日24小时,尚品客服全天竭诚为您服务!";
    [rectImageView addSubview:titleLable2];
    [titleLable2 release];
    
    //拨打客服电话按钮
    UIButton * tellButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    tellButton.frame = CGRectMake(50, 185, 220, 60);
    UIImage * image = [UIImage imageNamed:@"tellButton.png"];
    //UIImage * tbImage = [image stretchableImageWithLeftCapWidth:10 topCapHeight:4];
    [tellButton setBackgroundImage:image forState:UIControlStateNormal];
    tellButton.showsTouchWhenHighlighted = YES;
    tellButton.layer.masksToBounds = YES;
    tellButton.layer.cornerRadius = 3.0f;
    [tellButton addTarget:self action:@selector(nowTell) forControlEvents:UIControlEventTouchUpInside];
    [aboutView addSubview:tellButton];
    
    self.view = aboutView;
    [aboutView release];
    
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
*/
- (void)nowTell{
    NSLog(@"%s",__FUNCTION__);

//    NSSet *touches = [event allTouches]; 
//    UITouch *touch = [touches anyObject]; 
//    CGPoint currentTouchPosition = [touch locationInView:self.listTable]; 
//    NSIndexPath*indexPath=[self.listTable indexPathForRowAtPoint:currentTouchPosition]; 
//    if (indexPath == nil){ 
//        return; 
//    } 
//    NSInteger section = [indexPath section]; 
//    NSUInteger row = [indexPath row]; 
//    NSDictionary *rowData = [datas objectAtIndex:row]; 
    
    NSString * number = @"4006-900-900";
    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",number]; //number为号码字符串,"telprompt://%@"形式的,打完电话可以回到程序
                                                                              //"tell://%@"形式打完电话不能回到程序! 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号 
    [num release];

}



-(void)backButton{
    [self.navigationController popViewControllerAnimated:YES];
    
}



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

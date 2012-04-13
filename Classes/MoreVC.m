//
//  MoreVC.m
//  ShangPin
//
//  Created by 唐彬琪 on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MoreVC.h"
#import "HootLineVC.h"
#import "WeiBoVC.h"
#import "ServiceVC.h"
#import "SuggestVC.h"
#import "AboutShangpinVC.h"


@implementation MoreVC
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
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

    NSLog(@"更多界面加载");
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"More_Tittle.png"]];
    logoImageView.center = CGPointMake(160, [logoImageView center].y);
    self.navigationItem.titleView = logoImageView;
    [logoImageView release];

    UIView * mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 431)];
    mainView.backgroundColor = [UIColor blackColor];
    //背景图片
    UIImageView * backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 431)];
    backImageView.image = [UIImage imageNamed:@"MoreBackGround.png"];
    [mainView addSubview:backImageView];
    [backImageView release];
    
    UIScrollView * backScrView = [[UIScrollView alloc] initWithFrame:CGRectMake(70, 10, 180, 367)];
    backScrView.backgroundColor = [UIColor clearColor];//colorWithPatternImage:image_cen];
    backScrView.contentSize = CGSizeMake(180, 368);
    backScrView.showsVerticalScrollIndicator = NO;
    backScrView.delegate = self;
    [mainView addSubview:backScrView];
    [backScrView release];
    
    UIImage * image_cen = [[UIImage imageNamed:@"Layer_DownRound.png"]stretchableImageWithLeftCapWidth:0.0f topCapHeight:20.0];
    UIImageView * imageView_cen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 347)];
    imageView_cen.image = image_cen;
    imageView_cen.layer.masksToBounds = YES;
    imageView_cen.layer.cornerRadius = 8.0f;
    imageView_cen.layer.borderWidth = 0.2f;
    [backScrView addSubview:imageView_cen];
    [imageView_cen release];
    
    //处理button的图片
    UIImage * btuImage = [UIImage imageNamed:@"More_Btu.png"];
    UIImage * btuImageBJ = [btuImage stretchableImageWithLeftCapWidth:4.0f topCapHeight:0.0];
    
    //更多里面的五个按钮
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(26.5, 31, 127, 29);
    button1.titleLabel.font = [UIFont systemFontOfSize:15];
    //button1.titleLabel.text = @"客服热线";
    [button1 setTitle:@"客服热线" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor colorWithRed:0.263 green:0.027 blue:0.027 alpha:1.0] forState:UIControlStateHighlighted];
    button1.showsTouchWhenHighlighted = YES;
    [button1 setBackgroundImage:btuImageBJ forState:UIControlStateNormal];
    [button1 setBackgroundImage:btuImageBJ forState:UIControlStateHighlighted];
    button1.showsTouchWhenHighlighted = YES;
    button1.layer.masksToBounds = YES;
    button1.layer.cornerRadius = 5.0f;
    button1.layer.borderWidth = 0.2f;
    button1.tag = 2001;
    [button1 addTarget:self action:@selector(pushMoreVC:) forControlEvents:UIControlEventTouchUpInside];
    [backScrView addSubview:button1];
    
/*
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(26.5, 70, 127, 29);
    button2.titleLabel.font = [UIFont systemFontOfSize:15];
    //button2.titleLabel.text = @"官方微博";
    [button2 setTitle:@"官方微博" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor colorWithRed:0.263 green:0.027 blue:0.027 alpha:1.0] forState:UIControlStateHighlighted];
    button2.showsTouchWhenHighlighted = YES;
    [button2 setBackgroundImage:btuImageBJ forState:UIControlStateNormal];
    [button2 setBackgroundImage:btuImageBJ forState:UIControlStateHighlighted];
    button2.showsTouchWhenHighlighted = YES;
    button2.layer.masksToBounds = YES;
    button2.layer.cornerRadius = 5.0f;
    button2.layer.borderWidth = 0.2f;
    button2.tag = 2002;
    [button2 addTarget:self action:@selector(pushMoreVC:) forControlEvents:UIControlEventTouchUpInside];
    [backScrView addSubview:button2];
*/
 
    UIButton * button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //button3.frame = CGRectMake(26.5, 109, 127, 29);
    button3.frame = CGRectMake(26.5, 75, 127, 29);
    button3.titleLabel.font = [UIFont systemFontOfSize:15];
    //button3.titleLabel.text = @"服务承诺";
    [button3 setTitle:@"服务承诺" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor colorWithRed:0.263 green:0.027 blue:0.027 alpha:1.0] forState:UIControlStateHighlighted];
    button3.showsTouchWhenHighlighted = YES;
    
    [button3 setBackgroundImage:btuImageBJ forState:UIControlStateNormal];
    [button3 setBackgroundImage:btuImageBJ forState:UIControlStateHighlighted];
    button3.showsTouchWhenHighlighted = YES;
    button3.layer.masksToBounds = YES;
    button3.layer.cornerRadius = 5.0f;
    button3.layer.borderWidth = 0.2f;
    button3.tag = 2003;
    [button3 addTarget:self action:@selector(pushMoreVC:) forControlEvents:UIControlEventTouchUpInside];
    [backScrView addSubview:button3];
    
    UIButton * button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //button4.frame = CGRectMake(26.5, 148, 127, 29);
    button4.frame = CGRectMake(26.5, 119, 127, 29);
    button4.titleLabel.font = [UIFont systemFontOfSize:15];
    //button4.titleLabel.text = @"建议反馈";
    [button4 setTitle:@"建议反馈" forState:UIControlStateNormal];
    [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button4 setTitleColor:[UIColor colorWithRed:0.263 green:0.027 blue:0.027 alpha:1.0] forState:UIControlStateHighlighted];
    button4.showsTouchWhenHighlighted = YES;
    [button4 setBackgroundImage:btuImageBJ forState:UIControlStateNormal];
    [button4 setBackgroundImage:btuImageBJ forState:UIControlStateHighlighted];
    button4.showsTouchWhenHighlighted = YES;
    button4.layer.masksToBounds = YES;
    button4.layer.cornerRadius = 5.0f;
    button4.layer.borderWidth = 0.2f;
    button4.tag = 2004;
    [button4 addTarget:self action:@selector(pushMoreVC:) forControlEvents:UIControlEventTouchUpInside];
    [backScrView addSubview:button4];
    
    UIButton * button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //button5.frame = CGRectMake(26.5, 187, 127, 29);
    button5.frame = CGRectMake(26.5, 163, 127, 29);
    button5.titleLabel.font = [UIFont systemFontOfSize:15];
    //button5.titleLabel.text = @"关于尚品";
    [button5 setTitle:@"关于尚品" forState:UIControlStateNormal];
    [button5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button5 setTitleColor:[UIColor colorWithRed:0.263 green:0.027 blue:0.027 alpha:1.0] forState:UIControlStateHighlighted];
    button5.showsTouchWhenHighlighted = YES;
    [button5 setBackgroundImage:btuImageBJ forState:UIControlStateNormal];
    [button5 setBackgroundImage:btuImageBJ forState:UIControlStateHighlighted];
    button5.showsTouchWhenHighlighted = YES;
    button5.layer.masksToBounds = YES;
    button5.layer.cornerRadius = 5.0f;
    button5.layer.borderWidth = 0.2f;
    button5.tag = 2005;
    [button5 addTarget:self action:@selector(pushMoreVC:) forControlEvents:UIControlEventTouchUpInside];
    [backScrView addSubview:button5];
    
     self.view = mainView;
    [mainView release];
    
    NSNotificationCenter * logOutNotice = [NSNotificationCenter defaultCenter];
    [logOutNotice addObserver:self selector:@selector(releaseSuggestVC) name:@"renewSug" object:nil];
    
}


// Implement ;viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    NSLog(@"%s",__FUNCTION__);
    [super viewDidLoad];
 
}

//推出每个按钮对应的相关业,
- (void)pushMoreVC:(id)sender{
    NSLog(@"%s",__FUNCTION__);
    UIButton * button0 = (UIButton *)sender;
    NSInteger   num = button0.tag;
     switch (num) {
        case 2001:
        {   
            if (hootLineVC == nil) {
                hootLineVC = [[HootLineVC alloc] init];
            }
            [self.navigationController pushViewController:hootLineVC animated:YES];
        }
            break;
        case 2002:
        {    
            if (weiBoVC == nil) {
                weiBoVC = [[WeiBoVC alloc] init];
            }
            [self.navigationController pushViewController:weiBoVC animated:YES];
        } 
            break;
        case 2003:
        {
            if (serviceVC == nil) {
                serviceVC = [[ServiceVC alloc] init];
            }
            [self.navigationController pushViewController:serviceVC animated:YES];
        }   
            break;
        case 2004:
        {
            if (suggestVC == nil) {
                suggestVC = [[SuggestVC alloc] init];
            }
            [self.navigationController pushViewController:suggestVC animated:YES];

        }    
            break;
        case 2005:
        {    
            if (aboutShangpinVC == nil) {
                aboutShangpinVC = [[AboutShangpinVC alloc] init];
            }
            [self.navigationController pushViewController:aboutShangpinVC animated:YES];
        }    
            break;
            
        default:
            break;
    }
    
 
}

//接收到退出通知后，清空我的建议的内容；
- (void)releaseSuggestVC
{
    suggestVC = nil;
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

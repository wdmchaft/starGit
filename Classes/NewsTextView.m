//
//  textFeilview.m
//  ScrollImageDemo
//
//  Created by 唐彬琪 on 11-7-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NewsTextView.h"


@implementation NewsTextView
@synthesize textView;
@synthesize titleLabel,timeLabel;

- (void)dealloc
{
    [super dealloc];
    [textView release];
    [titleLabel release];
    [timeLabel release];
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
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];//[[UIScreen mainScreen]bounds]];
    backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"inforBack.JPG"]];
    [self.view addSubview:backView];
    [backView release];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];                //返回按钮
    backButton.frame = CGRectMake(10, 7, 50, 30);
    [backButton setBackgroundImage:[UIImage imageNamed:@"BackAll.png"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    backButton.showsTouchWhenHighlighted = YES;
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftNavigationButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftNavigationButton;
    [leftNavigationButton release];

    
    self.view.alpha = 1.0;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:0.761f green:0.639f blue:0.259f alpha:1.0f];
    [self.view addSubview:titleLabel];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, 20)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = UITextAlignmentCenter;
    timeLabel.textColor = [UIColor colorWithRed:0.761f green:0.639f blue:0.259f alpha:1.0f];
    [self.view addSubview:timeLabel];

    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, 320, 317)];
    textView.backgroundColor = [UIColor clearColor];
    textView.alpha = 1.0;
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.text = @""; 
    textView.textColor = [UIColor colorWithRed:0.761f green:0.639f blue:0.259f alpha:1.0f];
    [self.view addSubview:textView];
  }


- (void)backButton
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSNotificationCenter * stopTimer = [NSNotificationCenter defaultCenter];
    NSString * const StarTimerNotification = @"StarTimer";
    [stopTimer postNotificationName:StarTimerNotification object:self];
    
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
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

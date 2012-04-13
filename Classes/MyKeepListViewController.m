//
//  MyKeepListViewController.m
//  ShangPin
//
//  Created by tang binqi on 12-2-12.
//  Copyright (c) 2012年 shangpin. All rights reserved.
//

#import "MyKeepListViewController.h"
#import "CustomLabel.h"
#import "Catalog.h"
#import "Item.h"
#import "LoadingView.h"
#import "GDataXMLNode.h"

@implementation MyKeepListViewController
@synthesize receivedData;
@synthesize onsaleCatalogArray;
#pragma mark -
#pragma mark 返回 我的账户界面
- (void)returnBack
{
	[self.navigationController popViewControllerAnimated:YES];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        // Custom initialization
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

        
//        UIButton *_editButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _editButton.frame = CGRectMake(257, 0, 53, 29);
//        _editButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
//        [_editButton setTitle:@"完成" forState:UIControlStateSelected];
//        [_editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//        [_editButton setBackgroundImage:[UIImage imageNamed:@"BackAll.png"] forState:UIControlStateNormal]
//        [editButton addTarget:self action:@selector(setEditing) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *_editButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_editButton];
//        self.navigationItem.rightBarButtonItem = editButtonItem;
//        [editButtonItem release];
        [self.navigationItem setRightBarButtonItem:self.editButtonItem animated:YES];
        self.tableView.backgroundColor = [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.0f];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:1.0f];
        self.tableView.editing = NO;
        //self.tableView.a
        cellNum = 10;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) getMyKeepList
{
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    OnlyAccount *account = [OnlyAccount defaultAccount];
    NSString *parameters = [NSString stringWithFormat:@"%@",account.account];
    NSString *encodedString = [URLEncode encodeUrlStr:parameters];
    NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
    
    NSString *myKeep = [NSString stringWithFormat:@"%@=GetFavoriteList&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
    NSLog(@"我的账户中-我的收藏:%@",myKeep);
    NSURL *myKeepUrl = [[NSURL alloc] initWithString:myKeep];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:myKeepUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loadingView];
    KeepListConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [request release];
    [myKeepUrl release];
}


-(void) cancleKeep
{
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    OnlyAccount *account = [OnlyAccount defaultAccount];
    NSString *parameters = [NSString stringWithFormat:@"%@|%@",account.account,keepID];
    NSString *encodedString = [URLEncode encodeUrlStr:parameters];
    NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
    
    NSString *myKeep = [NSString stringWithFormat:@"%@=DeleteFavorite&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
    NSLog(@"我的账户中-取消收藏:%@",myKeep);
    NSURL *myKeepUrl = [[NSURL alloc] initWithString:myKeep];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:myKeepUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:loadingView];
    cancleKeepConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [request release];
    [myKeepUrl release];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
 
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 110.0f;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	return [self.onsaleCatalogArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        //cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x110.png"]];
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.0f]; 
            
            UIImageView *accImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Accessary.png"]];
            cell.accessoryView = accImg;
            [accImg release];
            
            UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 66.0f, 88.0f)];
            leftView.backgroundColor = [UIColor grayColor];
            leftView.tag = 100;
            [cell.contentView addSubview:leftView];
            [leftView release];
            
            //UIImageView *stateImgV = [[UIImageView alloc] initWithFrame:CGRectMake(54, 10, 22, 17)];
            //		stateImgV.tag = 101;
            //		[cell.contentView addSubview:stateImgV];
            //		[stateImgV release];
            
            CustomLabel *firstLb = [[CustomLabel alloc] initWithFrame:CGRectMake(86.0f, 8, 200, 32)];
            firstLb.tag = 200;
            firstLb.font = [UIFont systemFontOfSize:14];
            firstLb.textColor = WORDCOLOR;
            firstLb.numberOfLines = 0;
            firstLb.verticalAlignment = VerticalAlignmentTop;
            firstLb.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:firstLb];
            [firstLb release];
            
            UILabel *secondLb = [[UILabel alloc] initWithFrame:CGRectMake(86.0f, 40, 240.0f, 20.0f)];
            secondLb.tag = 201;
            secondLb.textColor = [UIColor whiteColor];
            secondLb.font = [UIFont systemFontOfSize:14];
            secondLb.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:secondLb];
            [secondLb release];
            
            UILabel *lineLB = [[UILabel alloc] initWithFrame:CGRectMake(86.0f, 50, 100.0f, 1.0f)];
            lineLB.tag = 199;
            lineLB.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
            [cell.contentView addSubview:lineLB];
            [lineLB release];
            
            UILabel *thirdLb = [[UILabel alloc] initWithFrame:CGRectMake(86.0f, 60, 240.0f, 20.0f)];
            thirdLb.tag = 202;
            thirdLb.textColor = [UIColor whiteColor];
            thirdLb.font = [UIFont systemFontOfSize:14];
            thirdLb.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:thirdLb];
            [thirdLb release];
            
            UILabel *fourLb = [[UILabel alloc] initWithFrame:CGRectMake(86.0f, 80, 240.0f, 20.0f)];
            fourLb.tag = 203;
            fourLb.textColor = [UIColor whiteColor];
            fourLb.font = [UIFont systemFontOfSize:14];
            fourLb.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:fourLb];
            [fourLb release];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        //Catalog *catalog = [self.onsaleCatalogArray objectAtIndex:indexPath.section];
        Item *item = [self.onsaleCatalogArray objectAtIndex:indexPath.row];
        
        UIImageView *leftView = (UIImageView *)[cell.contentView viewWithTag:100];
        leftView.image= [UIImage imageNamed:@"shang.png"];
        [ImageCacheManager setImg:leftView  withUrlString:item.img];
    //OnSale *onsale = [self.onSaleArray objectAtIndex:indexPath.row];
	//cell.m_imageView.image = nil; 
        
          CustomLabel *firstLb = (CustomLabel *)[cell.contentView viewWithTag:200];
        firstLb.text = item.Name;
        
        UILabel *secondLb = (UILabel *)[cell.contentView viewWithTag:201];
        secondLb.text = [NSString stringWithFormat:@"专柜价:%@",item.rackrate];
        
        float width = [self contentWidth:secondLb.text];
        UILabel *line = (UILabel *)[cell.contentView viewWithTag:199];
        line.frame = CGRectMake(86, 50, width, 1);
        
        UILabel *thirdLb = (UILabel *)[cell.contentView viewWithTag:202];
        thirdLb.text = [NSString stringWithFormat:@"限时价:%@",item.limitedprice];
        
//        if([item.Count intValue] < 10)
//        {
//            UILabel *fourLb = (UILabel *)[cell.contentView viewWithTag:203];
//            fourLb.text = [NSString stringWithFormat:@"剩余数量:%@",item.Count];
//        }
//        else
//        {
//            UILabel *fourLb = (UILabel *)[cell.contentView viewWithTag:203];
//            fourLb.text = @"货源充足";
//        }
        
        return cell;

    }
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    NSLog(@"是在设置编辑");
    [super setEditing:editing animated:animated];
    //self.tableView.frame = CGRectMake(30, 0, 290, 367);
}


//- (void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing:YES animated:YES];
//   [self setEditing:editing animated:YES];
//    
//    NSLog(@"可以编辑");
//    if (self.tableView.editing == YES)
//   {
//        self.tableView.editing =NO;
//    }else
//    {
//       self.tableView.editing = YES;
//    }    
//}
//
//-(void)setEditing
//{
//    [self setEditing: YES animated:YES];
//}


#pragma mark -
#pragma mark tableview methods

-(float)contentWidth: (NSString *)string
{
	CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(260, 500) lineBreakMode:UILineBreakModeCharacterWrap];
	float width = size.width;
	return width;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"开始表格设置");
    //self.tableView.frame = CGRectMake(0, 0, 280, 367);
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.frame = CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y, (cell.contentView.frame.size.width-30), cell.contentView.frame.size.height);

}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.frame = CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y, (cell.contentView.frame.size.width+30), cell.contentView.frame.size.height);

}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;

}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        Item *item =[self.onsaleCatalogArray objectAtIndex:indexPath.row];
        keepID = item.Type;
        [self cancleKeep];
        [self.onsaleCatalogArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



#pragma mark -
#pragma mark NSURLConnection delegate

//获取数据

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   	NSLog(@"个人信息 获得服务器 回应"); 
    NSMutableData * rData = [[NSMutableData alloc] init];
    self.receivedData = rData;
    [rData release];
	[self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
	NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
	NSError *error = nil;
    
	GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];

	if (connection == KeepListConnection) 
    {
        [loadingView finishLoading];
        [loadingView removeFromSuperview];
        [loadingView release];
        
            if(error)
            {
                [document release];
                [KeepListConnection release];
                self.navigationItem.leftBarButtonItem.enabled = YES;
                self.navigationItem.rightBarButtonItem.enabled = YES;
                return;
            }
            
            GDataXMLElement *root = [document rootElement];
            NSArray *items = [root elementsForName:@"item"];
            NSMutableArray * itemArray_self = [[NSMutableArray alloc] init];
            self.onsaleCatalogArray = itemArray_self;
            [itemArray_self release];
            for(GDataXMLElement *itemElement in items)
            {
                Item *item = [[Item alloc] init];
                GDataXMLElement *ID = [[itemElement elementsForName:@"id"] objectAtIndex:0];
                item.ID = [ID stringValue];
                GDataXMLElement *name = [[itemElement elementsForName:@"name"] objectAtIndex:0];
                item.Name = [name stringValue];
                GDataXMLElement *rackrate = [[itemElement elementsForName:@"rackrate"] objectAtIndex:0];
                item.rackrate = [rackrate stringValue];
                GDataXMLElement *level = [[itemElement elementsForName:@"level"] objectAtIndex:0];
                item.Level = [level stringValue];
                GDataXMLElement *limitedprice = [[itemElement elementsForName:@"limitedprice"] objectAtIndex:0];
                item.limitedprice = [limitedprice stringValue];
                GDataXMLElement *img = [[itemElement elementsForName:@"img"] objectAtIndex:0];
                item.img = [img stringValue];
                GDataXMLElement *type = [[itemElement elementsForName:@"fid"] objectAtIndex:0];
                item.Type = [type stringValue];
                [onsaleCatalogArray addObject:item];
                [item release];
            }
            NSLog(@"catalog.itemArray count = %d",[self.onsaleCatalogArray count]);
            [self.tableView reloadData];
            //[document release];
            [KeepListConnection release];
        
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;

           // [self showNine];
	
   }
    if (connection == cancleKeepConnection)
    {
        if(error)
        {
            [document release];
            [cancleKeepConnection release];
            self.navigationItem.leftBarButtonItem.enabled = YES;
            self.navigationItem.rightBarButtonItem.enabled = YES;
            return;
        }
        NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
		char flag = [str characterAtIndex:0];
		if(flag == '1')
		{
            NSLog(@"取消收藏   成功");
		}
		else
		{
            NSLog(@"取消收藏失败");
		}
        //[document release];
		[cancleKeepConnection release];
		self.navigationItem.leftBarButtonItem.enabled = YES;
		self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    self.receivedData = nil;
    [document release];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//	self.navigationItem.leftBarButtonItem.enabled = YES;
//	self.navigationItem.rightBarButtonItem.enabled = YES;
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];	
	[KeepListConnection release];
    [cancleKeepConnection release];
	self.receivedData = nil;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}




#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(buyDetailVC == nil)
	{
		buyDetailVC = [[OnsaleDetailViewController alloc] init];
	}
	//Catalog *catalog = [self.onsaleCatalogArray objectAtIndex:indexPath.section];
	Item *item = [self.onsaleCatalogArray objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:buyDetailVC animated:YES];
	[buyDetailVC detailInfo:item.ID catID:nil];
    [buyDetailVC hideKeepButton];
}





@end

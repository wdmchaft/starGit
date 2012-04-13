//
//  ImageCacheManager.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageCacheManager.h"


@implementation ImageCacheManager

NSString *g_cacheDirectory;


/*
 删除cache下的全部文件，此方法没有在.h中声明。
 但是+(void) initCacheDirectory 内部调用了此方法
 */
+(void) clearCache
{
	NSFileManager* fm = [NSFileManager defaultManager];
	NSDirectoryEnumerator* en = [fm enumeratorAtPath: g_cacheDirectory];
    
	NSError* err = nil;
	BOOL res;
	NSString* file = nil;
	while(file = [en nextObject]) 
	{
		res = [fm removeItemAtPath:[g_cacheDirectory stringByAppendingPathComponent:file] error:&err];
		if (!res && err) 
		{
			//NSLog(@"oops: %@", err);
		}
	}
	
}





/*
 获得cache路径，并且删除路径下的全部文件。内部调用了+(void) clearCache方法
 */
+(void) initCacheDirectory
{
	g_cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, //NSDocumentDirectory or NSCachesDirectory
															NSUserDomainMask, //NSUserDomainMask
															YES)	// YES
						objectAtIndex: 0];
	
	[g_cacheDirectory retain];
	
	[self clearCache];
}



/*
 异步下载指定url上的图片，并且设置给指定imageview
 传入的参数是一个数组，数组包含2部分内容，指定的imageview和指定的urlStr
 本方法不为外部调用，本类的+(void)setImg:(UIImageView *)imgView  withUrlString:(NSString *)urlStr内部使用到了本方法
 */
+(void) loadImg:(NSArray *)array
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	UIImageView *imgView = [array objectAtIndex:0];
	NSString *urlStr = [array objectAtIndex:1];
	NSString *imageCachePath = [urlStr stringByReplacingOccurrencesOfString: @"/" withString: @"_"];
	imageCachePath = [g_cacheDirectory stringByAppendingPathComponent: imageCachePath];
	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: urlStr]];
    [data writeToFile: imageCachePath atomically: YES];
	
	imgView.image = [UIImage imageWithContentsOfFile:imageCachePath];
	
	UIActivityIndicatorView *a = (UIActivityIndicatorView *)[imgView viewWithTag:555];
	[a stopAnimating];
	[a removeFromSuperview];
	
	[pool release];
}


/*
 外部可见。用来处理图片缓存。
 先看cache下是否有名为urlStr的图片,如果有直接给imgView设置上。如果没有，从urlStr地址处异步下载
 图片，并且存储到cache下，命名为urlStr，然后将此图片设置给imgView。
 程序中多处用到此方法。
 严格的说，图片名称不是urlStr，而是做了一些修改。
 例如urlStr wei http://11.png
 实际的文件名是 http:__11.png
 */
+(void)setImg:(UIImageView *)imgView  withUrlString:(NSString *)urlStr
{
	NSString *imageCachePath = [urlStr stringByReplacingOccurrencesOfString: @"/" withString: @"_"];
	imageCachePath = [g_cacheDirectory stringByAppendingPathComponent: imageCachePath]; 
	if([[NSFileManager defaultManager] fileExistsAtPath: imageCachePath])
	{
		imgView.image = [UIImage imageWithContentsOfFile:imageCachePath];
	}
	else
	{
		UIActivityIndicatorView *a = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
		a.frame = CGRectMake(0, 0, 20, 20);
		a.center = CGPointMake(imgView.frame.size.width/2, imgView.frame.size.height/2);
		a.tag = 555;
		[imgView addSubview:a];
		[a startAnimating];
		//[a release];
		NSArray *parameterArray = [NSArray arrayWithObjects: imgView, urlStr, nil];
		[self performSelectorInBackground:@selector(loadImg:) withObject:parameterArray];
	}
}


@end

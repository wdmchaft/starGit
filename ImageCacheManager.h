//
//  ImageCacheManager.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 本类用于缓存图片的管理。
 
 
 程序中所有网上获取到的图片都会存储到cache路径下。
 */


#import <Foundation/Foundation.h>


@interface ImageCacheManager : NSObject 

+(void) initCacheDirectory;
/*
 初始化缓存路径(cache路径),并且把cache路径下的文件全部删除，以备存储网上获取到的各个图片。
 此方法在 应用程序 每次 启动 的时候调用。即 ShangPinAppDelegate.m 32行。
*/



+(void)setImg:(UIImageView *)imgView  withUrlString:(NSString *)urlStr;
/*
 先看cache下是否有名为urlStr的图片,如果有直接给imgView设置上。如果没有，从urlStr地址处异步下载
 图片，并且存储到cache下，命名为urlStr，然后将此图片设置给imgView。
 程序中多处用到此方法。
 严格的说，图片名称不是urlStr，而是做了一些修改。
 例如urlStr wei http://11.png
 实际的文件名是 http:__11.png
 */



@end

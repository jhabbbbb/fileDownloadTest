//
//  ViewController.h
//  fileDownloadTest
//
//  Created by JinHongxu on 16/2/15.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#include <QuickLook/QuickLook.h>
@interface ViewController : UIViewController<QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (strong, nonatomic) NSString *filePath;

@end


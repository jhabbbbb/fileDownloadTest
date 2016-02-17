//
//  ViewController.m
//  fileDownloadTest
//
//  Created by JinHongxu on 16/2/15.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSString *fileURL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"phone": @"10086", @"pwd": @"10086"};
    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/log_in" parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSDictionary *dict = (NSDictionary *)responseObject;
         if ([[dict objectForKey:@"msg"] isEqualToString:@"登陆成功"]){
             NSLog(@"登陆成功");
         }
         else {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定"otherButtonTitles: nil];
             [alert show];
         }
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

- (IBAction)getFileList:(id)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/wenjian" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *dict = (NSArray *)responseObject;
        NSLog(@"%@", dict);
        
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (IBAction)getFileURL:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"fileid": @"1"};
    
    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/get_file_url" parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSLog(@"%@", dict);
        self.fileURL = [[NSString alloc] initWithFormat:@"http://121.42.157.180/qgfdyjnds/%@", [dict objectForKey:@"url"]];
        
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (IBAction)download:(id)sender {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:self.fileURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        self.filePath = [filePath absoluteString];
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
    
}

- (IBAction)open:(id)sender {
    QLPreviewController *myQlPreViewController = [[QLPreviewController alloc]init];
    myQlPreViewController.delegate = self;
    myQlPreViewController.dataSource = self;
    [myQlPreViewController setCurrentPreviewItemIndex:0];
    [self presentViewController:myQlPreViewController animated:YES completion:nil];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL URLWithString:self.filePath];
}


/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"quickLook"]){
        if ([segue.destinationViewController isKindOfClass:[quickLookViewController class]]){
            quickLookViewController *vc = (quickLookViewController *)segue.destinationViewController;
            vc.filePath = self.filePath;
        }
    }
}*/



@end

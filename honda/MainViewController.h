//
//  ViewController.h
//  honda
//
//  Created by jason on 12/7/12.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"
#import "SVProgressHUD.h"
#import "JSONKit.h"

@interface MainViewController : UIViewController <SRWebSocketDelegate, UITextViewDelegate, ZBarReaderViewDelegate>
{
    
}

@property (nonatomic, strong) SRWebSocket *myWebsocket;
@property (nonatomic, strong) NSString *index;
@property (weak, nonatomic) IBOutlet UILabel *stautsLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property (weak, nonatomic) IBOutlet ZBarReaderView *myReaderView;

- (IBAction)scanButtonPressed:(id)sender;

@end

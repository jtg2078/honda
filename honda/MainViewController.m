//
//  ViewController.m
//  honda
//
//  Created by jason on 12/7/12.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.myReaderView.readerDelegate = self;
    self.scanButton.enabled = YES;
    self.index = @"Honda-Accord";
}

- (void)viewDidUnload
{
    [self setStautsLabel:nil];
    [self setScanButton:nil];
    [self setMyReaderView:nil];
    [self setMyTextView:nil];
    [self setMyReaderView:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // run the reader when the view is visible
    [self.myReaderView start];
}

- (void) viewWillDisappear: (BOOL) animated
{
    //[self.myScanView stop];
    [super viewWillDisappear:animated];
}

#pragma mark - user interaction

- (IBAction)scanButtonPressed:(id)sender
{
    if([self.scanButton.titleLabel.text isEqualToString: @"連線"] == YES)
    {
        [self.myReaderView stop];
        [self connect];
    }
    else
    {
        [self.myWebsocket close];
        [self.myReaderView start];
        [self.scanButton setTitle:@"連線" forState:UIControlStateNormal];
    }
}

#pragma mark - main methods

- (void)connect
{
    NSString *urlString = @"ws://107.22.172.101:8080/ws/honda2?index=%@";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:urlString, self.index]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.myWebsocket = [[SRWebSocket alloc] initWithURLRequest:request];
    self.myWebsocket.delegate = self;
    [self.myWebsocket open];
    [SVProgressHUD showWithStatus:@"連線中"];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if(self.myWebsocket.readyState != SR_OPEN)
        return;
    
    NSString *text = @"";
    if(textView.text)
        text = textView.text;
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setObject:text forKey:@"msg"];
    [p setObject:self.index forKey:@"index"];
    
    NSData *jsonData =[p JSONData];
    [self.myWebsocket send:jsonData];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    self.stautsLabel.text = [NSString stringWithFormat:@"connected to box: %@", self.index];
    [SVProgressHUD showSuccessWithStatus:@"連線成功"];
    [self.scanButton setTitle:@"斷線" forState:UIControlStateNormal];
    self.myTextView.text = @"";
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    self.stautsLabel.text = @"連線失敗";
}

- (void)webSocket:(SRWebSocket *)webSocket
 didCloseWithCode:(NSInteger)code
           reason:(NSString *)reason
         wasClean:(BOOL)wasClean
{
    self.stautsLabel.text = @"已斷線";
}

#pragma mark - ZBarReaderViewDelegate

- (void) readerView: (ZBarReaderView*) view
     didReadSymbols: (ZBarSymbolSet*) syms
          fromImage: (UIImage*) img
{
    // do something useful with results
    for(ZBarSymbol *sym in syms) {
        self.stautsLabel.text = sym.data;
        self.scanButton.enabled = YES;
        self.index = sym.data;
        break;
    }
}


@end

/*
 #import "EmbedReaderViewController.h"
 
 @implementation EmbedReaderViewController
 
 @synthesize readerView, resultText;
 
 - (void) cleanup
 {
 [cameraSim release];
 cameraSim = nil;
 readerView.readerDelegate = nil;
 [readerView release];
 readerView = nil;
 [resultText release];
 resultText = nil;
 }
 
 - (void) dealloc
 {
 [self cleanup];
 [super dealloc];
 }
 
 - (void) viewDidLoad
 {
 [super viewDidLoad];
 
 // the delegate receives decode results
 readerView.readerDelegate = self;
 
 // you can use this to support the simulator
 if(TARGET_IPHONE_SIMULATOR) {
 cameraSim = [[ZBarCameraSimulator alloc]
 initWithViewController: self];
 cameraSim.readerView = readerView;
 }
 }
 
 - (void) viewDidUnload
 {
 [self cleanup];
 [super viewDidUnload];
 }
 
 - (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
 {
 // auto-rotation is supported
 return(YES);
 }
 
 - (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) orient
 duration: (NSTimeInterval) duration
 {
 // compensate for view rotation so camera preview is not rotated
 [readerView willRotateToInterfaceOrientation: orient
 duration: duration];
 }
 
 - (void) viewDidAppear: (BOOL) animated
 {
 // run the reader when the view is visible
 [readerView start];
 }
 
 - (void) viewWillDisappear: (BOOL) animated
 {
 [readerView stop];
 }
 
 - (void) readerView: (ZBarReaderView*) view
 didReadSymbols: (ZBarSymbolSet*) syms
 fromImage: (UIImage*) img
 {
 // do something useful with results
 for(ZBarSymbol *sym in syms) {
 resultText.text = sym.data;
 break;
 }
 }
 
 @end
 */

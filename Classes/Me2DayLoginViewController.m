//
//  Me2DayLoginViewController.m
//  PUMPL
//
//  Created by Harmandeep Singh on 17/07/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "Me2DayLoginViewController.h"
#import "JSON.h"
#import "Constants.h"
#import "DataManager.h"
#import "PMTabBarController.h"



@implementation Me2DayLoginViewController


@synthesize urlString;
@synthesize endPointCheckUrlString;
@synthesize alreadyLoggedInUrlString;


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
    mWebView.delegate = nil;
	[urlString release];
    [alreadyLoggedInUrlString release];
    [endPointCheckUrlString release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[mWebView loadRequest:request];
	
	self.title = @"me2day";
    
    UIColor *backgroundColor = [[UIColor alloc] initWithRed:0.91 green:0.91 blue:0.91 alpha:1.0];
	self.view.backgroundColor = backgroundColor;
    [backgroundColor release];
    
    self.navigationItem.leftBarButtonItem = [UITabBarController tabBarButtonWithImage:[UIImage imageNamed:@"BackBtn.png"]
                                                                               target:self action:@selector(back:)];
}


-(void) back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}





- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}







- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	
	
	return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	NSString *webViewUrlString = [[webView.request URL] absoluteString];
    

    //First Check for the already logged in string
    
    if([webViewUrlString isEqualToString:alreadyLoggedInUrlString])
	{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"You are already logged in to me2day. Please logout and try again" delegate:nil cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
        [alertView show];
        [alertView release];
	}
    else
    {
        NSRange endPointUrlRange = [webViewUrlString rangeOfString:endPointCheckUrlString];
        if(endPointUrlRange.location != NSNotFound)
        {
            NSString *html = [mWebView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
            NSString *preTagStartString = @"<pre style=\"word-wrap: break-word; white-space: pre-wrap;\">";
            NSString *preTagEndString = @"</pre>";
            
            NSRange preTagStartRange = [html rangeOfString:preTagStartString];
            NSRange preTagEndRange = [html rangeOfString:preTagEndString];
            
            if(preTagStartRange.location != NSNotFound && preTagEndRange.location != NSNotFound)
            {
                NSString *stringWithNoPreTagStart = [html stringByReplacingOccurrencesOfString:preTagStartString withString:@""];
                NSString *jsonResponseString = [stringWithNoPreTagStart stringByReplacingOccurrencesOfString:preTagEndString withString:@""];
                
                NSDictionary *responseDic = [jsonResponseString JSONValue];
                
                
                NSInteger code = [[responseDic valueForKey:@"code"] integerValue];
                if(code == 0)
                {
                    NSNumber *isMe2dayConnected = [[responseDic valueForKey:@"value"] valueForKey:@"is_me2day_connected"];
                    if(isMe2dayConnected && [isMe2dayConnected boolValue])
                    {
                        [[DataManager sharedDataManager] setMe2dayConnected:YES withNickname:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kNotificationMe2dayDidLogin object:nil]];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            }
        }
    }
}








@end

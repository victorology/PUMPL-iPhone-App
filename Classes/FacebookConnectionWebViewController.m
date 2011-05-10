//
//  FacebookConnectionWebViewController.m
//  PUMPL
//
//  Created by Harmandeep Singh on 05/05/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "FacebookConnectionWebViewController.h"
#import "JSON.h"
#import "Constants.h"


@implementation FacebookConnectionWebViewController

@synthesize urlString;
@synthesize endPointCheckUrlString;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[mWebView loadRequest:request];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	mWebView.delegate = nil;
	[urlString release];
    [super dealloc];
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	
	
	return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	NSString *webViewUrlString = [[webView.request URL] absoluteString];
	
	NSRange range = [webViewUrlString rangeOfString:endPointCheckUrlString];
	if(range.location != NSNotFound)
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
				NSNumber *isFacebookConnected = [[responseDic valueForKey:@"value"] valueForKey:@"is_facebook_connected"];
				if(isFacebookConnected && [isFacebookConnected boolValue])
				{
					[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kNotificationFBDidLogin object:nil]];
					[self.navigationController popViewControllerAnimated:YES];
				}
			}
		}
	}
}

@end

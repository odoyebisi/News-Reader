//
//  DetailViewController.m
//  NewsFeed
//
//  Created by Daniel Oyebisi on 14/1/16.
//  Copyright (c) 2016 EPITA. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation DetailViewController

@synthesize articleLabel;
@synthesize articleName;
@synthesize articleLink;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Set the Label text with the selected article
    articleLabel.text = articleName;
    
    // Initialize an activity indicator and set its properties
    UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityIndicator.color=[UIColor grayColor];

    [activityIndicator setCenter:self.view.center];
    self.activityIndicator=activityIndicator;
    
    [self.webView addSubview:self.activityIndicator];
    self.webView.delegate = self;
    
    // request the url
    NSString *fullURL = [articleLink stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL *url = [NSURL URLWithString:fullURL];
   
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
   
 
    [_webView loadRequest:requestObj];

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    //set activity indicator
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //remove activity indicator
    [self.activityIndicator stopAnimating];

}

/**
 * Autorotate to interface orientation
 **/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

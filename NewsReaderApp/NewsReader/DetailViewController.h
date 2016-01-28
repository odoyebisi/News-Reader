//
//  DetailViewController
//  NewsFeed
//
//  Created by Daniel Oyebisi on 14/1/16.
//  Copyright (c) 2016 EPITA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController {
      UIImageView   *theImageView;
}

@property (nonatomic, strong) IBOutlet UILabel *articleLabel;
@property (nonatomic, strong) NSString *articleName;
@property (nonatomic, strong) NSString *articleLink;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * activityIndicator;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

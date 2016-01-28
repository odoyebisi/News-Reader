//
//  MainViewController.h
//  NewsFeed
//
//  Created by Daniel Oyebisi on 14/1/16.
//  Copyright (c) 2016 EPITA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate> {
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
     NSMutableString *date;
    NSString *element;
    NSMutableString *imageURL;
}
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *mainLabel;



@end

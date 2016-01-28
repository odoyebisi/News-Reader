//
//  MainViewController.m
//  NewsFeed
//
//  Created by Daniel Oyebisi on 14/1/16.
//  Copyright (c) 2016 EPITA. All rights reserved.
//

#import "MainViewController.h"
#import "DetailViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController {
   
}

const int rowCount = 20; // 20 items can only be displayed
const int rowHeight = 80; //height of cell

@synthesize tableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Initialize table data
    static NSString *feedURLString = @"http://www.thelocal.fr/feeds/rss.php"; //rss feed link
    
    NSURL *url = [NSURL URLWithString:feedURLString];

    NSData *data = [NSData dataWithContentsOfURL:url];
    parser = [[NSXMLParser alloc] initWithData:data];
    feeds = [[NSMutableArray alloc] init];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];

}


- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    if ([element isEqualToString:@"item"]){
        item = [[NSMutableDictionary alloc] init];
        title = [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];
        date = [[NSMutableString alloc] init];
        imageURL = [[NSMutableString alloc] init];
    }
    
    if ([element isEqualToString:@"enclosure"]){
        imageURL = [attributeDict objectForKey:@"url"];
    }
    
    
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([element isEqualToString:@"title"]){
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]){
        [link appendString:string];
    }else if ([element isEqualToString:@"pubDate"]){
        [date appendString:string];
    }
    
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"item"]){
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
         [item setObject:date forKey:@"pubDate"];
         [item setObject:imageURL forKey:@"enclosure"];
        [feeds addObject:[item copy]];
       
    }
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSDictionary *userInfo = parseError.userInfo;
    NSNumber *lineNumber = userInfo[@"NSXMLParserErrorLineNumber"];
    NSNumber *errorColumn = userInfo[@"NSXMLParserErrorColumn"];
    NSString *errorMessage = userInfo[@"NSXMLParserErrorMessage"];
    NSLog(@"Error at line %@ and column %@: %@", lineNumber, errorColumn, errorMessage);
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ArticleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    cell.layer.borderWidth  = 2;
    cell.layer.borderColor  = [[UIColor whiteColor] CGColor];

    //set title
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail; // set wrapping on
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"title"];  // set title
    cell.textLabel.font = [UIFont systemFontOfSize:10.0];
    cell.textLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(80/255.0) blue:(169/255.0) alpha:1] ;
    
     //set date
    cell.detailTextLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"pubDate"]; // set date
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:7.0];

    //set image
    NSString *path = [[feeds objectAtIndex:indexPath.row] objectForKey:@"enclosure"];
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:data];
    
    if(image != nil){
        cell.imageView.image = image; // set if there is an image
    }
    else{
        cell.imageView.image = [UIImage imageNamed:@"no-image.png"]; // else set placeholder
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      return rowHeight;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showArticleDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"%@", indexPath);
        
        DetailViewController *destViewController = segue.destinationViewController;
        destViewController.articleName = [[feeds objectAtIndex:indexPath.row] objectForKey:@"title"];
        destViewController.articleLink = [[feeds objectAtIndex:indexPath.row] objectForKey:@"link"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData]; // to reload selected cell
}


/*
 * refresh button click action
 */
- (IBAction)refreshFeed:(id)sender {
     NSLog(@"refresh btn clicked");
    
      [tableView reloadData];

}


@end

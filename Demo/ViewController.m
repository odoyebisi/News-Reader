//
//  ViewController.m
//  Demo
//
//  Created by Guest User on 16/12/15.
//  Copyright (c) 2015 Guest User. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"news" withExtension:@"xml"];
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
        
    }
    
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([element isEqualToString:@"title"]){
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]){
        [link appendString:string];
    }
    
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"item"]){
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [feeds addObject:[item copy]];
    }
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"%@", feeds);
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSDictionary *userInfo = parseError.userInfo;
    NSNumber *lineNumber = userInfo[@"NSXMLParserErrorLineNumber"];
    NSNumber *errorColumn = userInfo[@"NSXMLParserErrorColumn"];
    NSString *errorMessage = userInfo[@"NSXMLParserErrorMessage"];
    NSLog(@"Error at line %@ and column %@: %@", lineNumber, errorColumn, errorMessage);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [feeds count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *tableIdentifier = @"SimpleTable Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if(cell==nil){
        
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
        
    }
    
    cell.textLabel.text = [[feeds objectAtIndex:indexPath.row ] objectForKey:@"title"];
    cell.imageView.image=[UIImage imageNamed:@"pics.jpg"];
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

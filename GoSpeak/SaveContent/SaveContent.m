//
//  SaveContent.m
//  GoSpeak
//
//  Created by Nguyen Van Toan on 05/05/2013.
//  Copyright (c) 2013 Horical. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SaveContent.h"

@interface SaveContent ()

@end

@implementation SaveContent
@synthesize contentStr;
@synthesize contentList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    self.title = @"Memory";
    
    contentList = [[NSMutableArray alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/indexPathName.plist", appShare.appPath]];
    if(!contentList)
    {
        contentList = [[NSMutableArray alloc] init];
    }
    
    contentStr = [[NSMutableDictionary alloc] init];
    
    for(int i=0; i<[contentList count]; i++)
    {
        NSString *key = [contentList objectAtIndex:i];
        NSString *txt = [[NSString alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.txt", appShare.appPath, key] encoding:NSUTF8StringEncoding error:nil];
        
        [contentStr setObject:txt forKey:key];
    }
    
    editStart = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(editStartPress)];
    editDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(editDonePress)];
    
    return self;
}

- (void) editDonePress
{
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = editStart;
}

- (void) editStartPress
{
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = editDone;
}

- (void) saveData:(NSString*)key object:(NSString*)obj
{
    [contentList writeToFile:[NSString stringWithFormat:@"%@/indexPathName.plist", appShare.appPath] atomically:YES];
    
    if(obj && ([obj length] > 0))
    {
        [obj writeToFile:[NSString stringWithFormat:@"%@/%@.txt", appShare.appPath, key] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    else
    {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@.txt", appShare.appPath, key] error:nil];
    }
}

- (void) removeDataWithKey:(NSString*)key
{
    [contentList removeObject:key];
    [contentStr removeObjectForKey:key];
    
    [self saveData:key object:nil];
}

- (void) saveContent:(NSString *)save
{
    if(save && ([save length] > 0))
    {
        NSString *txt = [[NSString alloc] initWithFormat:@"%@", save];
        
        NSString *key = [NSString stringWithFormat:@"%lf", [[NSDate date] timeIntervalSince1970]];
        [contentList addObject:key];
        [contentStr setObject:txt forKey:key];
        
        [self saveData:key object:txt];
        
        [[[[UIAlertView alloc] initWithTitle:@"Save" message:@"This content was saved!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease] show];
        
        [self.tableView reloadData];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag >= 100)
    {
        if(buttonIndex == 1)
        {
            [appShare.viewController saveContent];
            [appShare.viewController stopAll];
            appShare.viewController.content.text = [contentStr objectForKey:[contentList objectAtIndex:alertView.tag-100]];
            [appShare.nav popViewControllerAnimated:YES];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = editStart;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [contentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[[UITableViewCell alloc] init] autorelease];
    
    cell.textLabel.text = [contentStr objectForKey:[contentList objectAtIndex:indexPath.row]];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([appShare.viewController.content.text length] > 0)
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Save & Insert" message:@"Do you want to save and put this memory into the main content?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil] autorelease];
        alert.tag = 100+indexPath.row;
        [alert show];
    }
    else
    {
        [appShare.viewController stopAll];
        appShare.viewController.content.text = [contentStr objectForKey:[contentList objectAtIndex:indexPath.row]];
        [appShare.nav popViewControllerAnimated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString *key = [contentList objectAtIndex:indexPath.row];
        
        [contentStr removeObjectForKey:key];
        [contentList removeObjectAtIndex:indexPath.row];
        
        [self removeDataWithKey:key];
        
        [self.tableView reloadData];
    }
}
@end


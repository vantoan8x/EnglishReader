//
//  SaveContent.h
//  GoSpeak
//
//  Created by Nguyen Van Toan on 05/05/2013.
//  Copyright (c) 2013 Horical. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveContent : UITableViewController <UIAlertViewDelegate>
{
    UIBarButtonItem *editStart;
    UIBarButtonItem *editDone;
}

@property (nonatomic, assign) NSMutableArray *contentList;
@property (nonatomic, assign) NSMutableDictionary *contentStr;

- (void) saveContent:(NSString*)save;

@end

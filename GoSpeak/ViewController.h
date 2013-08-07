//
//  ViewController.h
//  GoSpeak
//
//  Created by Nguyen Van Toan on 05/05/2013.
//  Copyright (c) 2013 Horical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@class VSSpeechSynthesizer;

@interface ViewController : UIViewController <UIAlertViewDelegate, MPMediaPlayback>
{
    UIBarButtonItem *stoppAll;
    UIBarButtonItem *speakAll;
    UIBarButtonItem *speakGG;
    
    UIBarButtonItem *saveContent;
    UIBarButtonItem *memoryContent;
    UIBarButtonItem *clearContent;
    UIBarButtonItem *hideKeyboard;
    
    VSSpeechSynthesizer *speech;
    MPMoviePlayerViewController *mp;
}

@property (nonatomic, assign) UITextView *content;

- (void) stopAll;
- (void) saveContent;

@end

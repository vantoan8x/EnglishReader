//
//  ViewController.m
//  GoSpeak
//
//  Created by Nguyen Van Toan on 05/05/2013.
//  Copyright (c) 2013 Horical. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize content;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //self.title = @"Content";
    
    if(!speech)
    {
        speech = [[VSSpeechSynthesizer alloc] init];
        [speech setRate:(float)0.88];
        [speech setVolume:(float)0.88];
    }
    
    if(!content)
    {
        content = [[UITextView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:content];
        content.backgroundColor = [UIColor grayColor];
        content.font = [UIFont systemFontOfSize:20];
    }
    
    
    stoppAll = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStyleDone target:self action:@selector(stopAll)];
    speakAll = [[UIBarButtonItem alloc] initWithTitle:@"Speak" style:UIBarButtonItemStyleDone target:self action:@selector(speakAll)];
    speakGG = [[UIBarButtonItem alloc] initWithTitle:@"GG" style:UIBarButtonItemStyleDone target:self action:@selector(speakGoogle)];
    
    saveContent = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveContent)];
    memoryContent = [[UIBarButtonItem alloc] initWithTitle:@"Memory" style:UIBarButtonItemStyleDone target:self action:@selector(memoryContent)];
    clearContent = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleDone target:self action:@selector(clearContent)];
    
    hideKeyboard = [[UIBarButtonItem alloc] initWithTitle:@"Hide" style:UIBarButtonItemStyleDone target:self action:@selector(hideKeyboard)];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:speakGG, hideKeyboard, saveContent, memoryContent, clearContent, nil];
    self.navigationItem.rightBarButtonItem = speakAll;
    
    [self createPlayer];
}

- (void) createPlayer
{
    mp = [[MPMoviePlayerViewController alloc] init];
    
    [mp.moviePlayer setFullscreen:YES];
    [mp.moviePlayer setShouldAutoplay:YES];
    [mp.moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
    [mp.moviePlayer setMovieSourceType:MPMovieSourceTypeFile];
    [mp.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
}

- (void) startGoogleSpeak
{
    [[AVAudioSession sharedInstance] setDelegate:appShare];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    if(!mp)
    {
        [self createPlayer];
    }
    
    NSString *fileName = [NSString stringWithFormat:@"http://translate.google.com.vn/translate_tts?UTF-8&q=%@&tl=en", [content.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:fileName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse, NSData *data, NSError *error) {
        if(error)
        {
            [[[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", [error description]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        }
        else
        {
            NSString *fileName = [NSString stringWithFormat:@"%@/%lf.mp3", appShare.appPath, [[NSDate date] timeIntervalSince1970]];
            [data writeToFile:fileName atomically:YES];
            
            NSURL *url = [NSURL fileURLWithPath:fileName];
            [mp.moviePlayer setContentURL:url];
            [mp.moviePlayer play];
        }
    }];
}

- (void) onPlayFinished:(NSNotification*)notify
{
    [self stopAll];
}

- (void) stopGoogleSpeak
{
    if(mp)
    {
        if([mp.moviePlayer playbackState] == MPMoviePlaybackStatePlaying)
        {
            [mp.moviePlayer stop];
        }
    }
}

- (void) hideKeyboard
{
    [content resignFirstResponder];
}

-(void) saveContent
{
    [appShare.saveContent saveContent:content.text];
}

- (void) stopAll
{
    [self stopGoogleSpeak];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:speakGG, hideKeyboard, saveContent, memoryContent, clearContent, nil];
}

- (void) speakGoogle
{
    [self startGoogleSpeak];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:stoppAll, hideKeyboard, saveContent, memoryContent, clearContent, nil];
}

- (void) speakAll
{
    [speech startSpeakingString:content.text];
}

- (void) clearContent
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Speak" message:@"Are you sure to clear content?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Clear", nil] autorelease];
    alert.tag = 1;
    [alert show];
}

- (void) memoryContent
{
    [appShare.nav pushViewController:appShare.saveContent animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
            content.text = @"";
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    content.frame = self.view.frame;
    return YES;
}

@end

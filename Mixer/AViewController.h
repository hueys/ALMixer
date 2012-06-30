//
//  AViewController.h
//  Mixer
//
//  Created by Steven Huey on 6/29/12.
//  Copyright (c) 2012 ArtLogic. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface AViewController : UIViewController
{
   AVPlayer* _player;
   AVMutableComposition* _composition;
   NSMutableDictionary* _audioMixValues;  // track name -> volume level 0.0 - 1.0
   NSMutableDictionary* _audioMixTrackIDs; // track name -> track ID
}

// Action for our 4 sliders
- (IBAction)mix:(id)sender;

@end

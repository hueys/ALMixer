//
//  AViewController.m
//  Mixer
//
//  Created by Steven Huey on 6/29/12.
//  Copyright (c) 2012 ArtLogic. All rights reserved.
//

#import "AViewController.h"

#import <CoreMedia/CoreMedia.h>

@interface AViewController ()
- (void)setVolume:(float)volume forTrack:(NSString*)trackName;
- (void)applyAudioMix;
- (AVAssetTrack*)trackWithId:(CMPersistentTrackID)trackId;
@end

@implementation AViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewDidLoad
{
   // Set the background tile
   UIImage *backgroundTile = [UIImage imageNamed: @"subtle_stripes.png"];
   UIColor *backgroundPattern = [[UIColor alloc] initWithPatternImage:backgroundTile];
   [[self view] setBackgroundColor:backgroundPattern];
   
   // Setup
   _composition = [AVMutableComposition composition];
   
   _audioMixValues = [[NSMutableDictionary alloc] initWithCapacity:0];
   _audioMixTrackIDs = [[NSMutableDictionary alloc] initWithCapacity:0];
   
   // Insert the audio tracks into our composition
   NSArray* tracks = [NSArray arrayWithObjects:@"track1", @"track2", @"track3", @"track4", nil];
   NSString* audioFileType = @"wav";
   
   for (NSString* trackName in tracks)
   {
      AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:trackName ofType:audioFileType]]
                                                      options:nil];
      
      AVMutableCompositionTrack* audioTrack = [_composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];

      NSError* error;
      [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
                          ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0]
                           atTime:kCMTimeZero
                            error:&error];
      
      if (error)
      {
         NSLog(@"%@", [error localizedDescription]);
      }
      
      // Store the track IDs as track name -> track ID
      [_audioMixTrackIDs setValue:[NSNumber numberWithInteger:audioTrack.trackID]
                           forKey:trackName];
      
      // Set the volume to 1.0 (max) for the track
      [self setVolume:1.0f forTrack:trackName];
   }

   // Create a player for our composition of audio tracks. We observe the status so
   // we know when the player is ready to play
   AVPlayerItem* playerItem = [[AVPlayerItem alloc] initWithAsset:[_composition copy]];
   [playerItem addObserver:self
                forKeyPath:@"status"
                   options:0
                   context:NULL];
   
   _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
   
   [super viewDidLoad];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
   if ([keyPath isEqualToString:@"status"])
   {
      if (AVPlayerItemStatusReadyToPlay == _player.currentItem.status)
      {
         [_player play];
      }
   }
}

// Action for our 4 sliders
- (IBAction)mix:(id)sender
{
   UISlider* slider = (UISlider*)sender;
   
   [self setVolume:slider.value
          forTrack:[NSString stringWithFormat:@"track%d", slider.tag]];
   [self applyAudioMix];
}

#pragma mark -
#pragma mark Audio Mixing
// Set the volumne (0.0 - 1.0) for the given track
- (void)setVolume:(float)volume forTrack:(NSString*)audioTrackName
{
   [_audioMixValues setValue:[NSNumber numberWithFloat:volume] forKey:audioTrackName];
}

// Build and apply an audio mix using our volume values
- (void)applyAudioMix
{
   AVMutableAudioMix* mix = [AVMutableAudioMix audioMix];
   
   NSMutableArray* inputParameters = [[NSMutableArray alloc] initWithCapacity:0];
   
   [_audioMixTrackIDs enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL*stop) {
      AVAssetTrack* track = [self trackWithId:(CMPersistentTrackID)[(NSNumber*)obj integerValue]];
      
      AVMutableAudioMixInputParameters* params = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
      
      [params setVolume:[[_audioMixValues valueForKey:key] floatValue]
                 atTime:kCMTimeZero];
      
      [inputParameters addObject:params];
   }];
      
   mix.inputParameters = inputParameters;
   
   _player.currentItem.audioMix = mix;
}

// Find the AVAssetTrack with the given track ID
- (AVAssetTrack*)trackWithId:(CMPersistentTrackID)trackId
{
   NSInteger index = [_composition.tracks indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL* stop) {
      AVCompositionTrack* track = (AVCompositionTrack*)obj;
      
      return (BOOL)(trackId == track.trackID);
   }];
   
   if (index != NSNotFound)
   {
      return [_composition.tracks objectAtIndex:index];
   }
   else
   {
      return nil;
   }
}

@end

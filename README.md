ALMixer
=======

This is a simple demo of a multi-track mixer using the AVMutableComposition and AVPlayer classes from the AVFoundation framework. It requires iOS 4.0 or later.

You'll need to provide 4 audio tracks named track1.wav through track4.wav or modify lines 40 and 41 in the AViewController implementation. The audio files should be bundled within the Resources directory of the app.

The app creates an AVMutableComposition with four audio tracks, each starting at time 0 with a volume of 1.0, the max. It has four sliders, one for each track, that allow you to change the volume of the respective track while the composition is playing.

## Credits ##

[Mixer Image](http://www.flickr.com/photos/71775616@N08/6499052841/) by BobOne80
[Subtle Stripes Background Tile](http://subtlepatterns.com/?p=1222)
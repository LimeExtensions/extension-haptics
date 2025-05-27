#include "haptic.hpp"

#import <UIKit/UIKit.h>
#import <CoreHaptics/CoreHaptics.h>
#import <AVFoundation/AVFoundation.h>

@interface HapticManager : NSObject

@property (nonatomic, strong) CHHapticEngine *hapticEngine API_AVAILABLE(ios(13.0));

+ (instancetype)sharedInstance;
- (void)initialize;
- (void)dispose;
- (void)vibrateOneShot:(NSTimeInterval)duration intensity:(float)intensity sharpness:(float)sharpness;
- (void)vibratePattern:(NSArray<NSNumber *> *)durations intensities:(NSArray<NSNumber *> *)intensities sharpnesses:(NSArray<NSNumber *> *)sharpnesses;
- (void)vibratePatternFromData:(NSData *)fileData;

@end

@implementation HapticManager

+ (instancetype)sharedInstance
{
	static HapticManager *sharedInstance = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		sharedInstance = [[HapticManager alloc] init];
	});

	return sharedInstance;
}

- (instancetype)init
{
	self = [super init];

	if (self)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
	}

	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
	if (@available(iOS 13.0, *))
	{
		[self startEngineSafely];
	}
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
	if (@available(iOS 13.0, *))
	{
		[self stopEngineSafely:@"App moved to background"];
	}
}

- (void)startEngineSafely
{
	if (@available(iOS 13.0, *))
	{
		if (self.hapticEngine)
		{
			[self.hapticEngine startWithCompletionHandler:^(NSError * _Nullable error)
			{
				if (error)
					NSLog(@"Failed to start haptic engine: %@", error.localizedDescription);
			}];
		}
	}
}

- (void)stopEngineSafely:(NSString *)reason
{
	if (@available(iOS 13.0, *))
	{
		if (self.hapticEngine)
		{
			[self.hapticEngine stopWithCompletionHandler:^(NSError * _Nullable error)
			{
				if (error)
					NSLog(@"Failed to stop haptic engine (%@): %@", reason, error.localizedDescription);
				else
					NSLog(@"Haptic engine stopped successfully (%@)", reason);
			}];
		}
	}
}

- (void)initialize
{
	if (@available(iOS 13.0, *))
	{
		if (![CHHapticEngine capabilitiesForHardware].supportsHaptics)
		{
			NSLog(@"Device does not support haptics.");
			return;
		}

		NSError *error = nil;

		self.hapticEngine = [[CHHapticEngine alloc] initWithAudioSession:[AVAudioSession sharedInstance] error:&error];

		if (error)
		{
			NSLog(@"Failed to create haptic engine: %@", error.localizedDescription);

			self.hapticEngine = nil;

			return;
		}

		__weak HapticManager *weakSelf = self;

		self.hapticEngine.stoppedHandler = ^(CHHapticEngineStoppedReason reason)
		{
			NSLog(@"Haptic engine stopped: %ld", (long)reason);

			dispatch_async(dispatch_get_main_queue(), ^{
				switch (reason)
				{
					case CHHapticEngineStoppedReasonAudioSessionInterrupt:
					case CHHapticEngineStoppedReasonApplicationSuspended:
						break;
					case CHHapticEngineStoppedReasonIdleTimeout:
					case CHHapticEngineStoppedReasonSystemError:
						[weakSelf startEngineSafely];
						break;
					default:
						break;
				}
			});
		};

		self.hapticEngine.resetHandler = ^{
			NSLog(@"Haptic engine reset, restarting...");

			dispatch_async(dispatch_get_main_queue(), ^{
				[weakSelf startEngineSafely];
			});
		};

		[self startEngineSafely];
	}
}

- (void)dispose
{
	if (@available(iOS 13.0, *))
	{
		[self stopEngineSafely:@"dispose() called"];

		self.hapticEngine = nil;
	}
}

- (void)vibrateOneShot:(NSTimeInterval)duration intensity:(float)intensity sharpness:(float)sharpness
{
	if (@available(iOS 13.0, *))
	{
		if (!self.hapticEngine)
		{
			NSLog(@"Haptic engine is not initialized.");
			return;
		}

		NSError *error = nil;

		CHHapticEventParameter *intensityParam = [[CHHapticEventParameter alloc] initWithParameterID:CHHapticEventParameterIDHapticIntensity value:intensity];
		CHHapticEventParameter *sharpnessParam = [[CHHapticEventParameter alloc] initWithParameterID:CHHapticEventParameterIDHapticSharpness value:sharpness];
		CHHapticEvent *event = [[CHHapticEvent alloc] initWithEventType:(duration < 0.1) ? CHHapticEventTypeHapticTransient : CHHapticEventTypeHapticContinuous parameters:@[intensityParam, sharpnessParam] relativeTime:0 duration:duration];
		CHHapticPattern *pattern = [[CHHapticPattern alloc] initWithEvents:@[event] parameters:@[] error:&error];

		if (error)
		{
			NSLog(@"Failed to create haptic pattern: %@", error.localizedDescription);
			return;
		}

		id<CHHapticPatternPlayer> player = [self.hapticEngine createPlayerWithPattern:pattern error:&error];

		if (error)
		{
			NSLog(@"Failed to create haptic player: %@", error.localizedDescription);
			return;
		}

		[player startAtTime:0 error:&error];

		if (error)
			NSLog(@"Failed to start haptic player: %@", error.localizedDescription);
	}
}

- (void)vibratePattern:(NSArray<NSNumber *> *)durations intensities:(NSArray<NSNumber *> *)intensities sharpnesses:(NSArray<NSNumber *> *)sharpnesses
{
	if (@available(iOS 13.0, *))
	{
		if (!self.hapticEngine)
		{
			NSLog(@"Haptic engine is not initialized.");
			return;
		}

		if (durations.count != intensities.count || durations.count != sharpnesses.count)
		{
			NSLog(@"Array counts for durations, intensities, and sharpnesses do not match.");
			return;
   		}

		NSError *error = nil;
		NSMutableArray<CHHapticEvent *> *events = [NSMutableArray array];
		NSTimeInterval relativeTime = 0;

		for (NSInteger i = 0; i < durations.count; i++)
		{
			NSTimeInterval duration = [durations[i] doubleValue];

			if (duration <= 0)
   			{
				NSLog(@"Skipping event with non-positive duration at index %ld", (long) i);
				continue;
			}

			CHHapticEventParameter *intensityParam = [[CHHapticEventParameter alloc] initWithParameterID:CHHapticEventParameterIDHapticIntensity value:[intensities[i] floatValue]];
			CHHapticEventParameter *sharpnessParam = [[CHHapticEventParameter alloc] initWithParameterID:CHHapticEventParameterIDHapticSharpness value:[sharpnesses[i] floatValue]];
			CHHapticEvent *event = [[CHHapticEvent alloc] initWithEventType:(duration < 0.1) ? CHHapticEventTypeHapticTransient : CHHapticEventTypeHapticContinuous parameters:@[intensityParam, sharpnessParam] relativeTime:relativeTime duration:duration];

			[events addObject:event];

			relativeTime += duration;
		}

		CHHapticPattern *pattern = [[CHHapticPattern alloc] initWithEvents:events parameters:@[] error:&error];

		if (error)
		{
			NSLog(@"Failed to create haptic pattern: %@", error.localizedDescription);
			return;
		}

		id<CHHapticPatternPlayer> player = [self.hapticEngine createPlayerWithPattern:pattern error:&error];

		if (error)
		{
			NSLog(@"Failed to create haptic player: %@", error.localizedDescription);
			return;
		}

		[player startAtTime:0 error:&error];

		if (error)
			NSLog(@"Failed to start haptic player: %@", error.localizedDescription);
	}
}

- (void)vibratePatternFromData:(NSData *)fileData
{
	if (@available(iOS 13.0 , *))
	{
		if (!self.hapticEngine)
		{
			NSLog(@"Haptic engine is not initialized.");
			return;
		}

		NSError *error = nil;

		if (![self.hapticEngine playPatternFromData:fileData error:&error])
			NSLog(@"Failed to play haptic pattern: %@", error.localizedDescription);
	}
}

@end

void hapticInitialize(void)
{
	[[HapticManager sharedInstance] initialize];
}

void hapticDispose(void)
{
	[[HapticManager sharedInstance] dispose];
}

void hapticVibrateOneShot(double duration, float intensity, float sharpness)
{
	[[HapticManager sharedInstance] vibrateOneShot:duration intensity:intensity sharpness:sharpness];
}

void hapticVibratePattern(const double *durations, const float *intensities, const float *sharpnesses, int count)
{
	NSMutableArray<NSNumber *> *durationArray = [NSMutableArray arrayWithCapacity:count];
	NSMutableArray<NSNumber *> *intensityArray = [NSMutableArray arrayWithCapacity:count];
	NSMutableArray<NSNumber *> *sharpnessArray = [NSMutableArray arrayWithCapacity:count];

	for (int i = 0; i < count; i++)
	{
		[durationArray addObject:@(durations[i])];
		[intensityArray addObject:@(intensities[i])];
		[sharpnessArray addObject:@(sharpnesses[i])];
	}

	[[HapticManager sharedInstance] vibratePattern:durationArray intensities:intensityArray sharpnesses:sharpnessArray];
}

void hapticVibratePatternFromData(const void *bytes, size_t len)
{
	[[HapticManager sharedInstance] vibratePatternFromData:[NSData dataWithBytes:bytes length:len]];
}

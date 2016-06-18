//
//  BITalino.h
//  BITalino
//
//  Created by Jasmin Nisic on 17/06/16.
//  Copyright © 2016 JasminNisic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>
#import "BITalinoFrame.h"

#define LAST_COMMAND_NIL 0
#define LAST_COMMAND_START 1
#define LAST_COMMAND_STOP 2
#define LAST_COMMAND_BATTERY_THRESHOLD 3
#define LAST_COMMAND_SET_DIGITAL 4

@class BITalinoBLE;

@protocol BITalinoBLEDelegate <NSObject>

-(void)bitalinoDidConnect:(BITalinoBLE*)bitalino;
-(void)bitalinoDidDisconnect:(BITalinoBLE*)bitalino;
-(void)bitalinoRecordingStarted:(BITalinoBLE*)bitalino;
-(void)bitalinoRecordingStopped:(BITalinoBLE*)bitalino;
-(void)bitalinoBatteryThresholdUpdated:(BITalinoBLE*)bitalino;
-(void)bitalinoBatteryDigitalOutputsUpdated:(BITalinoBLE*)bitalino;

@end

@class BITalinoBLE;

@interface BITalinoBLE : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>{
    NSUUID* uuid;
    NSArray* selectedAnalogChannels;
    int sampleRate;
    int numOfSamples;
    int numOfBytes;
    
    void (^frameCompletion)(BITalinoFrame* frame);        
}

-(id)initWithUUID:(NSString*)identifier;
-(void)scanAndConnect;
-(void)startRecordingFromAnalogChannels:(NSArray*)channels withSampleRate:(NSInteger)sr numberOfSamples:(NSInteger)ns samplesCompletion:(void (^)(BITalinoFrame* frame))completion;
-(void)stopRecording;
-(void)disconnect;
-(void)setBatteryThreshold:(NSInteger)threshold;
-(NSString*)version;
-(void)setDigitalOutputs:(NSArray*)channels;

@property (nonatomic, readonly) BOOL isConnected;
@property (nonatomic, readonly) BOOL isRecording;
@property (nonatomic, strong) id<BITalinoBLEDelegate> delegate;


@end

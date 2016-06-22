//
//  ViewController.m
//  BITalinoBLE-Example
//
//  Created by Jasmin Nisic on 18/06/16.
//  Copyright © 2016 JasminNisic. All rights reserved.
//

#import "ViewController.h"

#define BITALINO_IDENTIFIER @"4510AAEC-C465-8FFD-A266-537A9590E6EE"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sampleRate = 1;
    
    bitalino = [[BITalinoBLE alloc] initWithUUID:BITALINO_IDENTIFIER];
    bitalino.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderThresholdOnChange:(id)sender {
    _lblThreshold.text=[NSString stringWithFormat:@"%.1f V", _sliderThreshold.value];
}

- (IBAction)btnSetThresholdOnTap:(id)sender {
    int threshold = (_sliderThreshold.value-_sliderThreshold.minimumValue)/(_sliderThreshold.maximumValue-_sliderThreshold.minimumValue)*63;
    if([bitalino isConnected] && ![bitalino isRecording]){
        [bitalino setBatteryThreshold:threshold];
    } else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Battery threshold can be set only when BITalino is connected and in idle mode." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)btnConnectOnTap:(id)sender {
    if(![bitalino isConnected]){
        [bitalino scanAndConnect];
    } else{
        [bitalino disconnect];
    }
}

- (IBAction)btnSampleRateOnTap:(UIButton *)sender {
    switch (sampleRate) {
        case 1:
            sampleRate=10;
            break;
        case 10:
            sampleRate=100;
            break;
        case 100:
            sampleRate=1000;
            break;
        case 1000:
            sampleRate=1;
            break;
        default:
            break;
    }
    [sender setTitle:[NSString stringWithFormat:@"%d Hz", sampleRate] forState:UIControlStateNormal];
}

- (IBAction)btnSetDigitalOnTap:(id)sender {
    if([bitalino isConnected] && ![bitalino isRecording]){
        NSArray* outputs = @[@([_switchD1 isOn]),
                             @([_switchD2 isOn]),
                             @([_switchD3 isOn]),
                             @([_switchD4 isOn])
                             ];
        [bitalino setDigitalOutputs:outputs];
    }else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Digital output values can be changed only when BITalino is connected and in idle mode." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)btnStartOnTap:(id)sender {
    if([bitalino isConnected]){
        if(![bitalino isRecording]){
            NSMutableArray* inputs = [[NSMutableArray alloc] init];
            if([_switchA0 isOn]){
                [inputs addObject:@(0)];
            }
            if([_switchA1 isOn]){
                [inputs addObject:@(1)];
            }
            if([_switchA2 isOn]){
                [inputs addObject:@(2)];
            }
            if([_switchA3 isOn]){
                [inputs addObject:@(3)];
            }
            if([_switchA4 isOn]){
                [inputs addObject:@(4)];
            }
            if([_switchA5 isOn]){
                [inputs addObject:@(5)];
            }
            
            [bitalino startRecordingFromAnalogChannels:inputs withSampleRate:sampleRate numberOfSamples:50 samplesCompletion:^(BITalinoFrame *frame) {
                NSLog(@"Frame acquired: %ld", frame.seq);
            }];
        } else{
            [bitalino stopRecording];
        }
    } else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"BITalino is not connected." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma BITalino delegates
-(void)bitalinoDidConnect:(BITalinoBLE *)bitalino{
    _lblStatus.text=@"Connected";
    [_btnConnect setTitle:@"Disconnect" forState:UIControlStateNormal];
}

-(void)bitalinoDidDisconnect:(BITalinoBLE *)bitalino{
    _lblStatus.text=@"Not connected";
    [_btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
}

-(void)bitalinoBatteryThresholdUpdated:(BITalinoBLE *)bitalino{
    NSLog(@"Battery threshold changed to %.2f V", _sliderThreshold.value);
}

-(void)bitalinoBatteryDigitalOutputsUpdated:(BITalinoBLE *)bitalino{
    NSLog(@"Digital outputs updated");
}

-(void)bitalinoRecordingStarted:(BITalinoBLE *)bitalino{
    [_btnStart setTitle:@"Stop" forState:UIControlStateNormal];
}

-(void)bitalinoRecordingStopped:(BITalinoBLE *)bitalino{
    [_btnStart setTitle:@"Start" forState:UIControlStateNormal];
}

@end

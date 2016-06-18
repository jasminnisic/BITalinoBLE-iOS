//
//  ViewController.h
//  BITalinoBLE-Example
//
//  Created by Jasmin Nisic on 18/06/16.
//  Copyright © 2016 JasminNisic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BITalinoBLE/BITalinoBLE.h>

@interface ViewController : UIViewController<BITalinoBLEDelegate>{
    int sampleRate;
    BITalinoBLE* bitalino;    
}

@property (weak, nonatomic) IBOutlet UILabel *lblThreshold;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UISlider *sliderThreshold;

- (IBAction)sliderThresholdOnChange:(id)sender;
- (IBAction)btnSetThresholdOnTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnConnect;
- (IBAction)btnConnectOnTap:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *switchD1;
@property (weak, nonatomic) IBOutlet UISwitch *switchD2;
@property (weak, nonatomic) IBOutlet UISwitch *switchD3;
@property (weak, nonatomic) IBOutlet UISwitch *switchD4;
- (IBAction)btnSampleRateOnTap:(UIButton *)sender;
- (IBAction)btnSetDigitalOnTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;
- (IBAction)btnStartOnTap:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *switchA0;
@property (weak, nonatomic) IBOutlet UISwitch *switchA1;
@property (weak, nonatomic) IBOutlet UISwitch *switchA2;
@property (weak, nonatomic) IBOutlet UISwitch *switchA3;
@property (weak, nonatomic) IBOutlet UISwitch *switchA4;
@property (weak, nonatomic) IBOutlet UISwitch *switchA5;


@end


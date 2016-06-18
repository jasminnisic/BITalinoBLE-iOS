# BITalinoBLE-iOS
BITalino (r)evolution (BITalino 2) example iOS application that uses Objective-C SDK from **BITalinoBLE.framework** (included in the project).

# How to import SDK
 1. Create new Xcode project (iOS application) and add BITalinoBLE.framework file to it. If you are adding it using drag and drop option, make sure that **Copy items if needed** is checked. 
 2. Enter project settings, go to **Target** and press **Build Phase**
 3. At top left of this page you will find **+** button - press it
 4. Select **New Copy Files Build Phase**
 5. Expand **Copy files** phase and drag BITalinoBLE.framework to this section
 6. Change **Destination** to **Frameworks**

BITalinoBLE SDK is now added to your project and you can use it.

![enter image description here](http://i.imgur.com/StbUzLR.png)

# BITalinoBLE SDK
Contains **BITalinoBLE** interface that encapsulates [BITalino](http://www.bitalino.com) (r)evolution protocol and utilities meant to write to/read from BITalino (r)evolution devices.

### **1. Initialization**

    -(id)initWithUUID:(NSString*)identifier;
    
BITalinoBLE object needs to be initialized with device UUID (passed as NSString*). In the example project identifier is declared as 

    #define BITALINO_IDENTIFIER @"4510AAEC-C465-8FFD-A266-537A9590E6EE"

and it should be default value, but there is no guarantee for that. The best option for you is to scan BLE devices by yourself and read CBPeripheral object UUID property.

### **2. Public interface**

 **1. `-(void)scanAndConnect;`**

+ Scans available BLE devices and connects the one with UUID equal to identifier passed during the object initialization. If the device is already connected it just logs the message. 

+ Fires `bitalinoDidConnect:` delegate method after establishing connection.

#

 **2.`-(void)startRecordingFromAnalogChannels:(NSArray*)channels withSampleRate:(NSInteger)sr numberOfSamples:(NSInteger)ns samplesCompletion:(void (^)(BITalinoFrame* frame))completion;`**
 
+ Switches BITalino to live mode and sets desired sample rate (1, 10, 100 or 1000 Hz). 

+ Parameter `channels` is NSArray of NSNumbers containing channel numbers that you want to read data from. For example, if you want to read data from A0, A1 and A4, this parameter will be `@[@(0), @(1), @(4)]`.

+ Parameter `numberOfSamples` means how many frames we want to acquire before processing. The less means getting frames more often, but increases CPU usage.

+ Parameter `completion` is block that gets every decoded frame as **BITalinoFrame** object and allows you to do whatever you want with acquired data.

+ Throws `BITalinoInvalidValueException` if invalid channel numbers are passed.

+ Throws `BITalinoInvalidValueException` if invalid sample rate value is passed.

+ Throws `BITalinoConnectionException` if BITalino is not connected.

+ Logs message if BITalino is already in recording state.

+ Fires `bitalinoRecordingStarted:` delegate method after starting recording.

#

 **3. `-(void)stopRecording;`**
 
+ Switches BITalino to idle mode.

+ Throws `BITalinoConnectionException` if BITalino is not connected.

+ Logs message if BITalino is already in idle state. 

+ Fires `bitalinoRecordingStopped:` delegate method after stopping recording.

#

**4. `-(void)disconnect;`**

+ Disconnects BITalino peripheral.

+ Logs message if BITalino is not connected.

+ Calls `stopRecording` if BITalino is in recording state.

+ Fires `bitalinoDidDisconnect:` delegate method after closing connection.

#

**5. `-(void)setBatteryThreshold:(NSInteger)threshold;`**

+ Sets the battery voltage threshold for the low-battery LED.

+ Parameter `threshold` must be between 0 (3.4 V) and 63 (3.8 V).

+ Throws `BITalinoInvalidValueException` if invalid threshold value is passed.

+ Throws `BITalinoConnectionException` if BITalino is not connected.

+ Logs message if BITalino is in recording state (battery threshold update is available only in idle state).

+ Fires `bitalinoBatteryThresholdUpdated:` delegate method on successful threshold update.

#

**6. `-(NSString*)version;`**

+ Reads BITalino firmware revision value.

+ Throws `BITalinoConnectionException` if BITalino is not connected.

+ Logs message if BITalino is in recording state (version is available only in idle state).

#

**7. `-(void)setDigitalOutputs:(NSArray*)channels;`**

+ Assigns the digital outputs states.

+ Parameter `channels` is NSArray of NSNumber values (0 or 1 - low or high) for each digital output, starting at first output (D1). Must contain exactly 4 elements. For example, if you want to set high output level to D1 and D4 and low output to D2 and D3, this parameter will be `@[@(1), @(0), @(0), @(1)]`.

+ Throws `BITalinoConnectionException` if BITalino is not connected.

+ Throws `BITalinoInvalidValueException` if invalid channel values are passed.

+ Fires `bitalinoBatteryDigitalOutputsUpdated:` delegate method on successful digital output values assignment.


### **3. Properties**

 `@property (nonatomic, readonly) BOOL isConnected;`
 `@property (nonatomic, readonly) BOOL isRecording;`
 `@property (nonatomic, strong) id<BITalinoBLEDelegate> delegate;`


### **4. BITalinoBLEDelegate**
Protocol that allows your class to be informed about BITalino events.

    -(void)bitalinoDidConnect:(BITalinoBLE*)bitalino;
    -(void)bitalinoDidDisconnect:(BITalinoBLE*)bitalino;
    -(void)bitalinoRecordingStarted:(BITalinoBLE*)bitalino;
    -(void)bitalinoRecordingStopped:(BITalinoBLE*)bitalino;
    -(void)bitalinoBatteryThresholdUpdated:(BITalinoBLE*)bitalino;
    -(void)bitalinoBatteryDigitalOutputsUpdated:(BITalinoBLE*)bitalino;


### **5. BITalinoFrame**

Simple class that contains results of decoding acquired frames.
 
    @property NSInteger seq;
 
 
4-bit sequential number generated by the firmware to identify the packet, which can be used on the receiver to detect loss of packets. Can have value from 0  to 15.

    @property NSInteger d0;
    @property NSInteger d1;
    @property NSInteger d2;
    @property NSInteger d3;

State of the digital input ports D1-D4 on the device.

    @property NSInteger a0;
    @property NSInteger a1;
    @property NSInteger a2;
    @property NSInteger a3;
    @property NSInteger a4;
    @property NSInteger a5;

Digital code produced by the ADC for the voltage at the corresponding analog input ports A1-A6; the first four channels have 10-bit resolution (ranging from 0-1024), while the last two have 6-bit (ranging from 0-63).


# BITalinoBLE-Example iOS App
It is pre-configured ready-to-use example app covering all the functionalities from the BITalinoBLE.framework.
![enter image description here](http://i.imgur.com/bS6PnMj.jpg)
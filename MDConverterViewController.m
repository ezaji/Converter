//
//  ViewController.m
//  Converter2GIS
//
//  Created by Dmitry on 01.06.16.
//  Copyright © 2016 MakarovDmitry. All rights reserved.
//

#import "MDConverterViewController.h"
#import "MDConverter.h"

#import "MDHTTPComunication.h"
#import "Reachability.h"

static NSString * const MDURLCurrencies = @"http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml";

static NSString * const MDDateUpdateKey = @"MDDateUpdateKey";

static const NSUInteger MDMaxLengthSourceValueTextKey = 15;

@interface MDConverterViewController () <UIPickerViewDelegate,
                                         UIPickerViewDataSource>

@property (nonatomic, strong) MDConverter *converter;
@property (nonatomic) MDUnit *toUnit;
@property (nonatomic) MDUnit *fromUnit;


@property (weak, nonatomic) IBOutlet UITextField *sourceValue;
@property (weak, nonatomic) IBOutlet UILabel *targetValue;
@property (weak, nonatomic) IBOutlet UILabel *dateUpdate;

@end

@implementation MDConverterViewController

#pragma mark - Life cycle method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.converter = [MDConverter ecbCurrencyConverter];
    self.fromUnit = self.converter.units[0];
    self.toUnit = self.converter.units[0];
    [self configureTargetValue];
    [self configureDateUpdate];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Configure view's
- (void)configureDateUpdate {
    NSDate *dateUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:MDDateUpdateKey];
    if(dateUpdate) {
        NSDateFormatter *dateUpdateFormatter = [[NSDateFormatter alloc] init];
        dateUpdateFormatter.dateFormat = @"dd.MM.yyyy";
        self.dateUpdate.text = [dateUpdateFormatter stringFromDate:dateUpdate];
    }
}

- (void)configureTargetValue {
    NSString *stringValueInBaseUnit = @"0.0";
    if(self.sourceValue.text.length > 0) {
        stringValueInBaseUnit = self.sourceValue.text;
    }
    MDConversionValue *convertiableValue = [[MDConversionValue alloc] initWithStringValue:stringValueInBaseUnit
                                                                                     unit:self.fromUnit];
    MDConversionValue *valueInTargetUnit = [self.converter convertWithConvertibleValue:convertiableValue
                                                                                toUnit:self.toUnit];
    self.targetValue.text = [valueInTargetUnit stringValue];
}

#pragma mark - IBAction's
- (IBAction)updateCurrencies:(id)sender {
    NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    
    switch (netStatus) {
        case NotReachable: {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Отсутствует интернет-соединение"
                                                                           message:@"Установите соединение и повторите попытку."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
        case ReachableViaWWAN:
        case ReachableViaWiFi:
            [self retrieveCurrencies];
            break;
    }
}

#pragma mark - Retrieve currencies
- (void)retrieveCurrencies {
    MDHTTPComunication *http = [[MDHTTPComunication alloc] init];
    NSURL *url = [NSURL URLWithString:MDURLCurrencies];
    [http retrieveURL:url
         successBlock:^(NSData *response) {
             if([response writeToFile:[[NSBundle mainBundle] pathForResource:@"eurofxref-daily"
                                                                      ofType:@".xml"]
                           atomically:YES]) {
                 NSLog(@"New file write");
                 NSDate *currentDate = [NSDate date];
                 [[NSUserDefaults standardUserDefaults] setObject:currentDate
                                                           forKey:MDDateUpdateKey];
                 [self configureDateUpdate];
                 self.converter = [MDConverter ecbCurrencyConverter];
             }
         }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return self.converter.units.count + 1;
}

#pragma mark - UIPickerViewDelete
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    if(row == self.converter.units.count) return self.converter.baseUnit.name;
    return self.converter.units[row].name;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    MDUnit *result = nil;
    if(row == self.converter.units.count)
        result = self.converter.baseUnit;
    else
        result = self.converter.units[row];
    if(pickerView.tag == 0) {
        self.fromUnit = result;
    } else if(pickerView.tag == 1) {
        self.toUnit = result;
    }
    [self configureTargetValue];
}

#pragma mark - Notification method
- (void)textFieldTextDidChange:(NSNotification *)notification {
    [self configureTargetValue];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    return newLength <= MDMaxLengthSourceValueTextKey;
}

@end

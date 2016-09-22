//
//  SyncViewController.m
//  SplitViewController
//
//  Created by vignesh on 9/22/16.
//  Copyright © 2016 vignesh. All rights reserved.


#import "SyncViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "SQLiteManager.h"

@interface SyncViewController ()

@end

@implementation SyncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionBtn:(id)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    
    [manager GET:@"http://localhost/~vignesh/PatientDetails.json" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSLog(@"JSON Data: %@", responseObject);
        
        [self updateSQLiteDB:responseObject];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
}
-(void)updateSQLiteDB:(NSDictionary*)responseObject{
    
    SQLiteManager *sqlManager = [[SQLiteManager alloc] init];
    [sqlManager OpenDB:[sqlManager GetDBPath]];
    
    NSArray *patientList = [responseObject objectForKey:@"Patients"];
    for(NSDictionary *patientDic in patientList){
        
        NSMutableArray *values = [[NSMutableArray alloc] init];
        NSNumber *patientID = (NSNumber*)[patientDic objectForKey:@"PatientID"];
       
            
            [values addObject:[patientDic objectForKey:@"UserName"]];
            [values addObject:[patientDic objectForKey:@"Gender"]];
            [values addObject:[patientDic objectForKey:@"UserImage"]];
            [values addObject:[patientDic objectForKey:@"Age"]];
            [values addObject:[patientDic objectForKey:@"EmailID"]];
            [values addObject:[patientDic objectForKey:@"PhoneNo"]];
            [values addObject:[patientDic objectForKey:@"MobileNo"]];
            [values addObject:[patientDic objectForKey:@"Language"]];
            [values addObject:[patientDic objectForKey:@"FinicialClass"]];
            [values addObject:[patientDic objectForKey:@"FinicalPayer"]];
            [values addObject:[patientDic objectForKey:@"AppoinmentDate"]];
            [values addObject:[patientDic objectForKey:@"ApponimentDoctorName"]];
            [values addObject:[patientDic objectForKey:@"LastApponimentDate"]];
            [values addObject:[patientDic objectForKey:@"ApponimentPlace"]];
            [values addObject:[patientDic objectForKey:@"Transportation"]];
            [values addObject:[patientDic objectForKey:@"RefreredDoctor"]];
            [values addObject:[patientDic objectForKey:@"LastSeenDoctor"]];
            [values addObject:[patientDic objectForKey:@"LastSeenDoctorPlace"]];
            [values addObject:[patientDic objectForKey:@"Diagonses"]];
            [values addObject:[patientDic objectForKey:@"DiagonsesDate"]];
            [values addObject:[patientDic objectForKey:@"Alleriges"]];
            [values addObject:[patientDic objectForKey:@"PharamacyName"]];
            [values addObject:patientID];
            
            BOOL isUpdated = [sqlManager ExecuteInsertQuery:@"UPDATE PatientDetails set UserName= ?, Gender= ?, UserImage=?, Age= ?, EmailID= ?, PhoneNo= ?, MobileNo= ?, Language= ?, FinicialClass= ?, FinicalPayer= ?, AppoinmentDate= ?, ApponimentDoctorName= ?, LastApponimentDate= ?, ApponimentPlace= ?, Transportation= ?, RefreredDoctor= ?, LastSeenDoctor= ?, LastSeenDoctorPlace= ?, Diagonses= ?, DiagonsesDate= ?, Alleriges= ?, PharamacyName= ? where PatientID= ?" withCollectionOfValues:values];
        
        NSLog(@"isUpdated : %d",isUpdated);
    }
    
}


@end



























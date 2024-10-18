//
//  DetailViewController.m
//  MiniProjectObjC
//
//  Created by west on 18/10/24.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *idNumber;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *body;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
            
    NSNumber *userIdNumber = [self.selectedData valueForKey:@"userId"];
    NSNumber *idNumber = [self.selectedData valueForKey:@"id"];
    
    if (self.selectedData != nil) {
        self.userId.text = [userIdNumber stringValue];
        self.idNumber.text = [idNumber stringValue];
        self.titleName.text = [self.selectedData valueForKey:@"title"];
        self.body.text = [self.selectedData valueForKey:@"body"];
    }
}

@end

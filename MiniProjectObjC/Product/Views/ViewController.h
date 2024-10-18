//
//  ViewController.h
//  MiniProjectObjC
//
//  Created by west on 18/10/24.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViewData;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end


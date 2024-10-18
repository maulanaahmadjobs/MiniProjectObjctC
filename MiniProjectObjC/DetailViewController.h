//
//  DetailViewController.h
//  MiniProjectObjC
//
//  Created by west on 18/10/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
/*
 {
    "userId": 1,
    "id": 1,
    "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
    "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
  }
 */

@property (nonatomic, strong) NSDictionary *selectedData;


@end

NS_ASSUME_NONNULL_END

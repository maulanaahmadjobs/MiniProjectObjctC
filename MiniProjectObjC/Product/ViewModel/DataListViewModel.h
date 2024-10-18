//
//  DataListViewModel.h
//  MiniProjectObjC
//
//  Created by west on 19/10/24.
//

#import <Foundation/Foundation.h>
#import "DataList.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataListViewModel : NSObject
@property (nonatomic, strong) NSArray<DataList *> dataList;
@property (nonatomic, strong) NSArray<DataList *> filterDaraList;

- (void) fetchDataListWithCompletion: (void (^)(NSError* error)) completion;
- (void) filertFetchDataListWithSearchText:(NSString* ) searchText;
@end

NS_ASSUME_NONNULL_END

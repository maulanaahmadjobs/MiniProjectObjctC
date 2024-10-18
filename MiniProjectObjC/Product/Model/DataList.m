//
//  DataList.m
//  MiniProjectObjC
//
//  Created by west on 19/10/24.
//

#import "DataList.h"

@implementation DataList

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _userId = dictionary[@"userId"];
        _postId = dictionary[@"id"];
        _title = dictionary[@"title"];
        _body= dictionary[@"body"];
    }
    return self;
}

@end

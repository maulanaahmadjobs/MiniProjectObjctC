//
//  DataListViewModel.m
//  MiniProjectObjC
//
//  Created by west on 19/10/24.
//

#import "DataListViewModel.h"

@implementation DataListViewModel

- (void)fetchDataListWithCompletion:(void (^)(NSError * _Nonnull))completion {
    NSDictionary* body;
    
    // 0. Init URL String
    NSString* url = @"https://jsonplaceholder.typicode.com/posts";
    
    // 1. URL type string
    NSURL* urlString = [NSURL URLWithString:url];
    
    //2. Create request with URL
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:urlString];
    [urlRequest setHTTPMethod:@"GET"];// "GET", "POST", "PUT", "DELETE"
    
    // 3. Set Header (misalnya JSON)
    [urlRequest setValue:@"applicaion/json" forHTTPHeaderField:@"Content-Type"];
    
    // 4. If body for POST and PUT
    if (body) {
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingFragmentsAllowed error:nil];
        [urlRequest setHTTPBody:jsonData];
    }
    
    // 5. Buat session dengan konfigurasi
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 30.0; // timout interval
    
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    // 6. Buat data task
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // Handle error (timeout, network issues, etc.)
        if (error) {
            if (error.code == NSURLErrorTimedOut) {
                NSLog(@"Request timed out");
            } else if (error.code == NSURLErrorNotConnectedToInternet) {
                NSLog(@"No internet connection");
            } else {
                NSLog(@"Request failed: %@", error.localizedDescription);
            }
            
            completion(error);
            return;
        }
        
        // Handle HTTP response
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *) response;
        if (httpResponse.statusCode == 200) {
            NSError* jsonError = nil;
            NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            
            if (!jsonError) {
                NSLog(@"Success: %@", jsonResponse);
                
                self->dataAPI = jsonResponse;
                self->filteredData = self->dataAPI;
                
                // Reload tableview in main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableViewData reloadData];
                });
                
            } else {
                NSLog(@"Failed to parse JSON: %@", jsonError.localizedDescription);
            }
        } else {
            NSLog(@"Request failed with status code: %ld", (long)httpResponse.statusCode);
            NSError *statusError = [NSError errorWithDomain:@"" code:httpResponse.statusCode userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Failed with status code: %ld", (long)httpResponse.statusCode]}];
        }
    }];
    [dataTask resume];
}

@end

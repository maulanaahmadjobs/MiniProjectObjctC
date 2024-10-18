//
//  ViewController.m
//  MiniProjectObjC
//
//  Created by west on 18/10/24.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSArray* dataAPI;
    NSArray* filteredData;
    NSString* currentSearchText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewData.delegate = self;
    self.tableViewData.dataSource = self;
    self.searchBar.delegate = self;
    
    //init Array kosong
    dataAPI = @[];
    filteredData = @[];
    
    filteredData = dataAPI;
    currentSearchText = @"";

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



/*
 "id": 1,
 "title"
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return filteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    // Mengambil post dari array
        NSDictionary *viewAPI = filteredData[indexPath.row];
        
        if (viewAPI) {
            NSNumber* idNumber = viewAPI[@"id"];
            NSString* idString = [idNumber stringValue];

            NSString* title = viewAPI[@"title"];
            
//            cell.textLabel.text = [idNumber stringValue];
//            cell.detailTextLabel.text = title;
            // Menggunakan NSAttributedString untuk highlight
            cell.textLabel.attributedText = [self highlightText:currentSearchText inString:idString];
            cell.detailTextLabel.attributedText = [self highlightText:currentSearchText inString:title];
        } else {
            NSLog(@"Post not found for index: %ld", (long)indexPath.row);
        }
    return cell;
}

// Search
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    currentSearchText = searchText;

    if (searchText.length == 0) {
        filteredData = dataAPI;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@", searchText];
        filteredData = [dataAPI filteredArrayUsingPredicate:predicate];
    }
    
    // Reload tableview using pencarian
    [self.tableViewData reloadData];
}

#pragma mark - Highlighting Text
- (NSAttributedString *)highlightText:(NSString *)searchText inString:(NSString *)originalString {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:originalString];
    
    if (searchText.length == 0) {
        return attributedString;
    }
    
    NSRange searchRange = NSMakeRange(0, originalString.length);
    NSRange foundRange;
    
    while (searchRange.location < originalString.length) {
        searchRange.length = originalString.length - searchRange.location;
        foundRange = [originalString rangeOfString:searchText options:NSCaseInsensitiveSearch range:searchRange];
        
        if (foundRange.location != NSNotFound) {
            [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:foundRange];
            searchRange.location = foundRange.location + foundRange.length;
        } else {
            break;
        }
    }
    
    return attributedString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *viewAPI = filteredData[indexPath.row];
    
    DetailViewController* detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailVC.selectedData = viewAPI;
    [self.navigationController pushViewController:detailVC animated:YES];

    NSLog(@"INI APAAN ==> %@", viewAPI);
}

@end

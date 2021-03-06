//
//  MoviesList.m
//  NerderyCodeChallenge
//
//  Created by Sergey Klimov on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MoviesFetcher.h"
#import "Movie.h"
#import "AFNetworking.h"
#import "RottenTomatoesAPI.h"
#import "MovieData.h"

@implementation MoviesFetcher
@synthesize delegate, fetchedMovies;
-(id)init {
    if (self = [super init]) {
        queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

-(void) fetchTopTenBoxOfficeMovies{
    NSSet* savedMoviesNames = [MovieData savedMoviesIds];
    NSURLRequest *request = [NSURLRequest requestWithURL:[RottenTomatoesAPI topBoxOfficeMoviesLimit:10+[savedMoviesNames count]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSMutableArray * result = [[NSMutableArray alloc] init];
                for (NSDictionary* movieProperties in [JSON objectForKey:@"movies"]) {
                    if (![savedMoviesNames containsObject: [movieProperties objectForKey:@"id"]])
                        [result addObject:[[Movie alloc] initWithProperties:movieProperties]];
                };
                self.fetchedMovies = [NSArray arrayWithArray:result];
                [self.delegate moviesFetcher:self fetchedMovies: self.fetchedMovies];
                
            }     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                [self.delegate moviesFetcherFetchFailure:self];
            }];
    
    [queue addOperation:operation];
    
}

@end

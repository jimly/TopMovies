//
//  Movie.m
//  NerderyCodeChallenge
//
//  Created by Sergey Klimov on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Movie.h"
#import "RottenTomatoesAPI.h"

@implementation Movie
@synthesize properties = _properties;

-(id) initWithProperties:(NSDictionary*) properties; {
    if (self = [super init]) {
        self.properties = properties;
    }
    return self;
}

-(NSString*) name {
    return [self.properties objectForKey:@"title"];
}

-(NSString*) synopsis {
    return [self.properties objectForKey:@"synopsis"];
}

-(NSUInteger) runtime {
    return [[self.properties objectForKey:@"runtime"] intValue];
}

-(NSUInteger) criticsScore {
    return [[[self.properties objectForKey:@"ratings"] objectForKey:@"critics_score"] intValue];
}

-(NSString*) criticsFreshness {
    return [[self.properties objectForKey:@"ratings"] objectForKey:@"critics_rating"];
}

-(NSDictionary*) cast {
    NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
    for (NSDictionary * actorAndRole in [self.properties objectForKey:@"abridged_cast"]) {
        NSArray * characters = [actorAndRole objectForKey:@"characters"];
        
        [result setObject: [characters objectAtIndex:0] forKey: [actorAndRole objectForKey:@"name"]];
    }
    return [NSDictionary dictionaryWithDictionary:result];
}

-(UIImage*) ratingImage {
    return [UIImage imageNamed:[[self.properties objectForKey:@"mpaa_rating"] lowercaseString]];
}


-(NSURL*) urlPosterWithSize:(MoviePosterSize) size {
    NSString* sizeName = nil;
    switch (size) {
        case MoviePosterSizeDetailed:
            sizeName = @"detailed";
            break;
        case MoviePosterSizeOriginal:
            sizeName = @"original";
            break;
        case MoviePosterSizeProfile:
            sizeName = @"profile";
            break;
        case MoviePosterSizeThumbnail:
            sizeName = @"thumbnail";
            break;
            
        default:
            break;
    }
    return [NSURL URLWithString:[[self.properties objectForKey:@"posters"] objectForKey:sizeName]];
}

@end

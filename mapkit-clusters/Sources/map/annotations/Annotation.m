
// BSD License. <jano@jano.com.es>

#import "Annotation.h"

@implementation Annotation

@synthesize title, subtitle, coordinate;
@synthesize clusterId, spawnPoint;
@synthesize view;


- (id) init
{
    self = [super init];
    if (!self) return nil;
    [super doesNotRecognizeSelector:_cmd];
    return nil;
}


-(id) initWithCoordinate:(CLLocationCoordinate2D)aCoordinate {
    self = [super init];
    if (self!=nil){
        self.coordinate = aCoordinate;
        //self.point = CGPointMake(0.0, 0.0);
        self.clusterId = -1;
        self.title=@"";
        self.subtitle=@"";
    }
    
    return self;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"clusterId=%d, title=%@, subtitle=%@, coordinate=%f,%f", 
            self.clusterId, self.title, self.subtitle, 
            self.coordinate.latitude, self.coordinate.longitude];
}

@end

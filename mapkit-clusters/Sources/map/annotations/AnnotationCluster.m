
// BSD License. <jano@jano.com.es>

#import "AnnotationCluster.h"

@implementation AnnotationCluster

@synthesize annotations=_annotations;


/**
 * @param aPoint      The centroid of the cluster. TODO: either remove this or add coordinate as a parameter
 * @param aClusterId  A identifier that can be the index in the array. 
 *                    This is used only to debug: "element jumped from cluster x to y"
 */
-(id) initWithId:(int)clusterId andCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super initWithCoordinate:coordinate];
    if (self!=nil){
        self.annotations = [NSMutableArray array];
        self.clusterId = clusterId;
    }
    return self;
}


-(void) addAnnotation:(Annotation*)annotation { 
    if (![annotation isMemberOfClass:[Annotation class]]){
        warn(@"Only Annotation objects should be added! you are adding a %@", [annotation class]);
    }
    annotation.clusterId = self.clusterId;
    [self.annotations addObject:annotation];
}


/** Label for the annotation callout. */
- (NSString *)title {
    return [NSString stringWithFormat:@"%d pins", self.annotations.count];
}


-(id)init {
    self = [super init];
    self.annotations = [NSMutableArray array];
    return self;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%@,  [annotations count]=%d", 
            [super description], [self.annotations count]];
}


-(CLLocationCoordinate2D) coordinate {
    return [super coordinate];
}

-(void) setCoordinate:(CLLocationCoordinate2D) aCoordinate {
    [super setCoordinate:aCoordinate];
}


@end

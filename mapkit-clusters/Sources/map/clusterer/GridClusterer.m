
// BSD License. <jano@jano.com.es>

#import "GridClusterer.h"

@implementation GridClusterer


- (id) init {
    return [super init];
}


/**
 * Return an array of 'numClusters' annotation clusters containing the given annotations.
 */
-(NSMutableArray*) clusterAnnotations:(NSMutableArray*)annotations 
                        inNumClusters:(int)numClusters {
    
    // calculate the number of rows*columns that are roughly equal to numClusters
    GridSize gridSize = [self gridSizeForClusters:numClusters];
    
    // create the annotation clusters
    NSMutableArray *clusters = [super clustersForGrid:gridSize];

    // size of each tile of the grid
    CGSize size = [self.mapView frame].size;
    const int width = floor(size.width/gridSize.cols);
    const int height = floor(size.height/gridSize.rows);
    debug(@"Each cluster tile is %d*%d.", width, height);

    // find out the size of the tile in degrees
    CLLocationCoordinate2D a = [self.mapView convertPoint:CGPointMake(width,height) toCoordinateFromView:self.mapView];
    CLLocationCoordinate2D b = [self.mapView convertPoint:CGPointMake(0,0) toCoordinateFromView:self.mapView];
    CLLocationCoordinate2D tileSize = { fabs(a.latitude-b.latitude), fabs(a.longitude-b.longitude) };
    
    // for each annotation...
    int clusterId = 0;
    for (Annotation *item in annotations){

        //item.point = [self.mapView convertCoordinate:item.coordinate toPointToView:self.mapView];
        
        // for each cluster...
        BOOL found = NO;
        for (AnnotationCluster *cluster in clusters){

            // is the annotation in the tile for this cluster?
            BOOL match = fabs(item.coordinate.longitude-cluster.coordinate.longitude)<= (tileSize.longitude/2.0) &&
                         fabs(item.coordinate.latitude-cluster.coordinate.latitude)<= (tileSize.latitude/2.0);
            if (match){ 
                // YES: add it
                [cluster.annotations addObject:item];
                found = YES;
                break;
            }
        }
        
        // did we add the annotation to a cluster?
        if (!found){
            // NO: create a new cluster, and add the annotation
            AnnotationCluster *cluster = [[AnnotationCluster alloc] initWithId:clusterId 
                                                                 andCoordinate:item.coordinate];
            clusterId++;
            [cluster.annotations addObject:item];
            [clusters addObject:cluster];
            warn(@"I had to create a new cluster at %f,%f", item.coordinate.latitude, item.coordinate.longitude);
        }
    }

    return clusters;
}


@end

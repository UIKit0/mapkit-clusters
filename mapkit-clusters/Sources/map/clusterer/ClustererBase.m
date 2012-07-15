
// BSD License. <jano@jano.com.es>

#import "ClustererBase.h"

@implementation ClustererBase

@synthesize mapView;

/**
 * Prevents init from being used.
 * See the reference for doesNotRecognizeSelector:.
 */
- (id) init
{
    self = [super init];
    if (!self) return nil;
    [super doesNotRecognizeSelector:_cmd];
    return nil;
}


/**
 * Initialize with a reference to MKMapView, 
 * which is used in clusterCoordinatesForGrid for the size of the frame, and to convert points.
 */
-(id) initWithMap:(MKMapView*)aMapView {
    self = [super init];
    if (self){
        self.mapView=aMapView;
    }
    return self;
}


/**
 * Return an array of AnnotationCluster objects for the given 'gridSize'.
 */
-(NSMutableArray*) clustersForGrid:(GridSize)gridSize 
{
    NSMutableArray *clusters = [[NSMutableArray alloc] init];
    NSMutableArray *clustersCoords = [self clusterCoordinatesForGrid:gridSize];
    for (int i=0;i<[clustersCoords count];i++) {
        CLLocation *location = [clustersCoords objectAtIndex:i];
        CLLocationCoordinate2D clusterCoord = { location.coordinate.latitude, location.coordinate.longitude };
        
        // create the annotation clusters
        AnnotationCluster *cluster = [[AnnotationCluster alloc] initWithId:i andCoordinate:clusterCoord];
        [clusters addObject:cluster];
        
        // add a pin on the cluster position for debugging purposes
        if (FALSE){
            SimpleAnnotation *annotation = [[SimpleAnnotation alloc] init];
            annotation.coordinate=clusterCoord;
            [self.mapView addAnnotation:annotation];
        }
    }
    return clusters;
}


/**
 * Return the coordinates for the centers of the annotation clusters.
 */
-(NSMutableArray*) clusterCoordinatesForGrid:(GridSize)gridSize {
    
    NSMutableArray *centerPoints = [[NSMutableArray alloc] init];
    
    // get width and height of each tile of the grid
    CGSize size = [self.mapView frame].size;
    const int width = floor(size.width/gridSize.cols);
    const int height = floor(size.height/gridSize.rows); 
    
    MKCoordinateRegion region = [self.mapView region];
    
    // set the coordinate on the bottom left corner of the current region
    CLLocationCoordinate2D corner = { 0,0 };
    corner.longitude = region.center.longitude - region.span.longitudeDelta/2; 
    corner.latitude = region.center.latitude - region.span.latitudeDelta/2;
    CGPoint cornerPoint = [self.mapView convertCoordinate:corner toPointToView:self.mapView];
    
    for (int col=0; col<gridSize.cols; col++) {
        for (int row=0; row<gridSize.rows; row++) {
            // center of the current tile
            CGPoint point = { (cornerPoint.x + col*width)+width/2, (cornerPoint.y - row*height)-height/2 };
            // add a pin
            CLLocationCoordinate2D coord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
            [centerPoints addObject:location];
        }        
    }
    
    return centerPoints;
}


/**
 * Returns the closest number of rows and columns that satisfies files*columns ~= numClusters.
 */
-(GridSize) gridSizeForClusters:(int)numClusters 
{    
    // split the screen in x*y tiles so x*y =~ numClusters
    // iPhone screen is 480*320. Since 480/320=1.5 then x*(x*1.5)=numClusters --> x=sqrtf(numClusters/1.5)
    float tilesX = sqrtf(numClusters/1.5);
    float tilesY = tilesX*1.5;
    
    int floorX = floorf(tilesX);
    int floorY = floorf(tilesY);
    
    int ceilX = ceilf(tilesX);
    int ceilY = ceilf(tilesY);
    
    int closestX=floorX, closestY=floorY;
    if ( abs(numClusters-closestX*closestY) > abs(numClusters-ceilX*ceilY) ){
        closestX = ceilX;
        closestY = ceilY;
    }
    if ( abs(numClusters-closestX*closestY) > abs(numClusters-floorX*ceilY) ){
        closestX = floorX;
        closestY = ceilY;
    }
    if ( abs(numClusters-closestX*closestY) > abs(numClusters-ceilX*floorY) ){
        closestX = ceilX;
        closestY = floorY;
    }
    
    GridSize gridSize;
    gridSize.cols = closestX;
    gridSize.rows = closestY;
    
    trace(@"You asked for %d clusters, I give you %d %d*%d.", numClusters, gridSize.cols*gridSize.rows, closestX, closestY);
    /*
     trace(@"    %d (%d)  %d,%d  floor", floorX*floorY, abs(numClusters-(floorX*floorY)), floorX, floorY);
     trace(@"    %d (%d)  %d,%d  ceil", ceilX*ceilY, abs(numClusters-(ceilX*ceilY)), ceilX, ceilY);
     trace(@"    %d (%d)  %d,%d  floor*ceil", floorX*ceilY, abs(numClusters-(floorX*ceilY)), floorX, ceilY);
     trace(@"    %d (%d)  %d,%d  ceil*floor", ceilX*floorY, abs(numClusters-(ceilX*floorY)), ceilX, floorY);
     */

    return gridSize;
}


@end

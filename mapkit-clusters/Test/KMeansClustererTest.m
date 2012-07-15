
typedef struct {
    int numTilesX;
    int numTilesY;
} GridSize;


@interface KMeansClustererTest : GHTestCase { }
-(GridSize) testGridSizeForClusters:(int)numClusters;
@end


@implementation KMeansClustererTest

-(void) testFoo {
    for (int i=0; i<64; i+=2) {
        [self testGridSizeForClusters:i];
    }
}
    
-(GridSize) testGridSizeForClusters:(int)numClusters {
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
    gridSize.numTilesX = closestX;
    gridSize.numTilesY = closestY;
    
    debug(@"%d CLUSTERS", numClusters);
    debug(@"    %d (%d)  %d,%d  <--", closestX*closestY, abs(numClusters-(closestX*closestY)), closestX, closestY);
    
    return gridSize;
    /*
    debug(@"    %d (%d)  %d,%d  floor", floorX*floorY, abs(numClusters-(floorX*floorY)), floorX, floorY);
    debug(@"    %d (%d)  %d,%d  ceil", ceilX*ceilY, abs(numClusters-(ceilX*ceilY)), ceilX, ceilY);
    debug(@"    %d (%d)  %d,%d  floor*ceil", floorX*ceilY, abs(numClusters-(floorX*ceilY)), floorX, ceilY);
    debug(@"    %d (%d)  %d,%d  ceil*floor", ceilX*floorY, abs(numClusters-(ceilX*floorY)), ceilX, floorY);
    */
}


@end


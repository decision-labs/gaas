  mm_kernel_src = <<EOS
extern "C" {
    __global__ void matrixMul(float *a, float *b, float *c, int matix_size) {
        __shared__ float tileA[TILE_WIDTH][TILE_WIDTH];
        __shared__ float tileB[TILE_WIDTH][TILE_WIDTH];
        int bx = blockIdx.x; int by = blockIdx.y;
        int tx = threadIdx.x; int ty = threadIdx.y;
        //index to work on
        int Row = by * TILE_WIDTH + ty;
        int Col = bx * TILE_WIDTH + tx;
        float Pvalue = 0.0f;
        for(int i = 0; i<matrix_size/TILE_WIDTH; i++) {
          tileA[ty][tx] = A[Row*matrix_size + (i*TILE_WIDTH + tx)];
          tileB[ty][tx] = B[(i*TILE_WIDTH + ty)*MATRIX_WIDTH + Col];
          __syncthreads();

          for (int j=0; j<TILE_WIDTH; j++) {
            Pvalue += tileA[ty][j]*tileB[j][tx];
          }

          c[Row][Col] = Pvalue;
        }
    }
EOS


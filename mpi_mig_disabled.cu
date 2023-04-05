#include <cuda.h>
#include <mpi.h>
#include <stdio.h>

#define BLOCK_SIZE 16

__global__ void addition(float *left, float *right, float *res, int dim) {

    int i,j;
    float temp = 0;

    __shared__ float Left_shared_t [BLOCK_SIZE][BLOCK_SIZE];
    __shared__ float Right_shared_t[BLOCK_SIZE][BLOCK_SIZE];

    // Row i of matrix left
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;


    for (int tileNUM = 0; tileNUM < gridDim.x; tileNUM++) {

        // Column j of matrix left
        j = tileNUM * BLOCK_SIZE + threadIdx.x;
        i = tileNUM * BLOCK_SIZE + threadIdx.y;
        // Load left[i][j] to shared mem

        Left_shared_t[threadIdx.y][threadIdx.x] = left[row * dim + j];// Coalesced access
        // Load right[i][j] to shared mem

        Right_shared_t[threadIdx.y][threadIdx.x] = right[i * dim + col]; // Coalesced access
        // Synchronize before computation
        __syncthreads();

        // Accumulate one tile of res from tiles of left and right in shared mem
        for (int k = 0; k < BLOCK_SIZE; k++) {

            temp += Left_shared_t[threadIdx.y][k] * Right_shared_t[k][threadIdx.x]; //no shared memory bank conflict
        }
        // Synchronize
        __syncthreads();
    }
    // Store accumulated value to res
    res[row * dim + col] = temp;
}
__global__ void multiply(float *left, float *right, float *res, int dim) {

    int i,j;
    float temp = 0;

    __shared__ float Left_shared_t [BLOCK_SIZE][BLOCK_SIZE];
    __shared__ float Right_shared_t[BLOCK_SIZE][BLOCK_SIZE];

    // Row i of matrix left
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;


    for (int tileNUM = 0; tileNUM < gridDim.x; tileNUM++) {

        // Column j of matrix left
        j = tileNUM * BLOCK_SIZE + threadIdx.x;
        i = tileNUM * BLOCK_SIZE + threadIdx.y;
        // Load left[i][j] to shared mem

        Left_shared_t[threadIdx.y][threadIdx.x] = left[row * dim + j];// Coalesced access
        // Load right[i][j] to shared mem

        Right_shared_t[threadIdx.y][threadIdx.x] = right[i * dim + col]; // Coalesced access
        // Synchronize before computation
        // Accumulate one tile of res from tiles of left and right in shared mem
        for (int k = 0; k < BLOCK_SIZE; k++) {

            temp += Left_shared_t[threadIdx.y][k] * Right_shared_t[k][threadIdx.x]; //no shared memory bank conflict
        }
        // Synchronize
        __syncthreads();
    }
    // Store accumulated value to res
    res[row * dim + col] = temp;
}
int main(int argc, char* argv[]){

        float *left1, *right1, *left2, *right2, *res1, *res2;
        float *left1_d, *right1_d, *left2_d, *right2_d, *res1_d, *res2_d;
        int dummy = 0;

        int width = atoi(argv[1]);
        //int width = 8196;
        int size = width * width * sizeof(float);

        cudaMallocHost((void **)&left1, size);
        cudaMallocHost((void **)&left2, size);
        cudaMallocHost((void **)&right1, size);
        cudaMallocHost((void **)&right2, size);
        cudaMallocHost((void **)&res1, size);
        cudaMallocHost((void **)&res2, size);

        for(int i = 0; i < width; i++){
                for(int j = 0; j < width; j++){
                        dummy = width * i + j;
                        left1[dummy] = sinf(dummy);
                        right2[dummy] = cosf(dummy);
                }
        }

        for(int i = 0; i < width; i++){
                for(int j = 0; j < width; j++){
                        dummy = width * i + j;
                        right1[dummy] = cosf(dummy);
                        left2[dummy] = sinf(dummy);
                }
        }

        cudaMalloc((void **)&left1_d, size);
        cudaMalloc((void **)&left2_d, size);
        cudaMalloc((void **)&right1_d, size);
        cudaMalloc((void **)&right2_d, size);
        cudaMalloc((void **)&res1_d, size);
        cudaMalloc((void **)&res2_d, size);

        cudaMemcpy(left1_d, left1, size, cudaMemcpyHostToDevice);
        cudaMemcpy(left2_d, left2, size, cudaMemcpyHostToDevice);
        cudaMemcpy(right1_d, right1, size, cudaMemcpyHostToDevice);
        cudaMemcpy(right2_d, right2, size, cudaMemcpyHostToDevice);
        cudaMemcpy(res1_d, res1, size, cudaMemcpyHostToDevice);
        cudaMemcpy(res2_d, res2, size, cudaMemcpyHostToDevice);

        dim3 Block_dim(BLOCK_SIZE, BLOCK_SIZE);
        dim3 Grid_dim(width / BLOCK_SIZE, width / BLOCK_SIZE);

                                                          
	        MPI_Init(NULL, NULL);

        int world_size;
        MPI_Comm_size(MPI_COMM_WORLD, &world_size);
        int world_rank;
        MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

        if(world_rank == 0){

                cudaEvent_t start, stop;
                cudaEventCreate(&start);
                cudaEventCreate(&stop);

                cudaEventRecord(start,0);

                multiply<<<Grid_dim, Block_dim>>>(left1_d, right1_d, res1_d, width);

                cudaEventRecord(stop,0);
                cudaEventSynchronize(stop);

                cudaDeviceSynchronize();
                cudaMemcpy(res1, res1_d, size, cudaMemcpyDeviceToHost);

                float et = 0;
                cudaEventElapsedTime(&et, start, stop);

                cudaEventDestroy(start);
                cudaEventDestroy(stop);
                printf("%f\n", et);


        }
        else{

                cudaEvent_t start, stop;
                cudaEventCreate(&start);
                cudaEventCreate(&stop);

                cudaEventRecord(start,0);

                //addition<<<Grid_dim, Block_dim>>>(left2_d, right2_d, res2_d, width);
                multiply<<<Grid_dim, Block_dim>>>(left1_d, right1_d, res2_d, width);

                cudaEventRecord(stop,0);
                cudaEventSynchronize(stop);

                cudaDeviceSynchronize();
                cudaMemcpy(res2, res2_d, size, cudaMemcpyDeviceToHost);

                float et = 0;
                cudaEventElapsedTime(&et, start, stop);

                cudaEventDestroy(start);
                cudaEventDestroy(stop);
                printf("%f\n", et);


        }

        MPI_Finalize();

        cudaFreeHost(left1);
        cudaFreeHost(left2);
        cudaFreeHost(right1);
        cudaFreeHost(right2);
        cudaFreeHost(res1);
        cudaFreeHost(res2);
	
        cudaFree(left1_d);
        cudaFree(left2_d);
        cudaFree(right1_d);
        cudaFree(right2_d);
        cudaFree(res1_d);
        cudaFree(res2_d);



	return 0;
}

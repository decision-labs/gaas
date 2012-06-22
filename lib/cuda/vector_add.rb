require 'tempfile'
require 'rbconfig'
require 'rubycuda'
include SGC::Cuda
include SGC::Cuda::CudaMemory

module VectorAdd

  def self.perform(va, vb)
    puts "Vector Addition"
    n = va.size
    ha = Buffer.new(:float, n)
    hb = Buffer.new(:float, n)
    hc = Buffer.new(:float, n)

    (0..n-1).each do |i|
      ha[i] = va[i]
      hb[i] = vb[i]
    end

    # Allocate device buffers.
    nbytes = n*Buffer.element_size(:float)
    da = CudaDeviceMemory.malloc(nbytes)
    db = CudaDeviceMemory.malloc(nbytes)
    dc = CudaDeviceMemory.malloc(nbytes)

    # Copy input buffers from host memory to device memory.
    memcpy_htod(da, ha, nbytes)
    memcpy_htod(db, hb, nbytes)
    
    # Invoke vadd kernel.
    nthreads_per_block = 256
    block_dim = Dim3.new(nthreads_per_block)
    grid_dim = Dim3.new((n + nthreads_per_block - 1) / nthreads_per_block)
    CudaFunction.configure(block_dim, grid_dim)
    CudaFunction.setup(da, db, dc, n)
    f = CudaFunction.new("vadd")
    f.launch

    # Copy output buffer from device memory to host memory.
    memcpy_dtoh(hc, dc, nbytes)

    # Free device buffers.
    da.free
    db.free
    dc.free

    result = []
    (0..hc.size-1).each do |i|
      result << hc[i]  
    end
    result
  end


end

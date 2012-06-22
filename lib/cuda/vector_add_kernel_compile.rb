require 'tempfile'
require 'rbconfig'
require 'rubycuda'
include SGC::Cuda
include SGC::Cuda::CudaMemory


module VectorAddKernelCompile

  # @todo Use internal compiler helpers once they are ready.
  def self.compile(src_str)
    src_file = Tempfile.new(["kernel_src", ".cu"])
    src_file.write(src_str)
    src_file.close

    out_file = Tempfile.new(["kernel", ".so"])
    out_file.close

    case RbConfig::CONFIG['target_os']
    when /darwin/    # Build universal binary for i386 and x86_64 platforms.
      f32 = Tempfile.new(["kernel32", ".so"])
      f64 = Tempfile.new(["kernel64", ".so"])
      f32.close
      f64.close
      system %{nvcc -shared -m32 -Xcompiler -fPIC #{src_file.path} -o #{f32.path}}
      system %{nvcc -shared -m64 -Xcompiler -fPIC #{src_file.path} -o #{f64.path}}
      system %{lipo -arch i386 #{f32.path} -arch x86_64 #{f64.path} -create -output #{out_file.path}}
    else    # Build default platform binary.
      system %{nvcc -shared -Xcompiler -fPIC #{src_file.path} -o #{out_file.path}}
    end

    out_file
  end

  vadd_kernel_src = <<EOS
extern "C" {
    __global__ void vadd(const float* a, const float* b, float* c, int n)
    {
        int i = blockDim.x * blockIdx.x + threadIdx.x;
        while(i < n){
          c[i] = a[i] + b[i];
          i += blockDim.x * gridDim.x;
        }
    }
}
EOS

  CudaDevice.current = ENV['DEVID'].to_i if ENV['DEVID']

  # Prepare and load vadd kernel.
  kernel_lib_file = compile(vadd_kernel_src)
  CudaFunction.load_lib_file(kernel_lib_file.path)

  #CudaFunction.unload_all_libs

end

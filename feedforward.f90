program main
   use forpy_mod
   use iso_fortran_env, only: real64
   implicit none
   
   integer :: ierror
   type(module_py) :: pytorch2fortran
   type(list) :: paths
   type(ndarray) :: w0_py,w1_py,w2_py,b0_py,b1_py,b2_py
   type(object) :: return_obj
   type(tuple) :: args

   real(kind=real64), dimension(:,:), pointer :: w1,w2,w3
   real(kind=real64), dimension(:), pointer :: b1,b2,b3
   !real, dimension(4, 64) :: w1
   !real, dimension(64) :: b1
   !real, dimension(64,64) :: w2
   !real, dimension(64) :: b2
   !real, dimension(64,16) :: w3
   !real, dimension(16) :: b3
   
   real, dimension(4)  :: x1 ! input vector
   real, dimension(64) :: x2 ! hidden layer 1
   real, dimension(64) :: x3 ! hidden layer 2
   real, dimension(16) :: y  ! output vector
   
   integer :: i

   ierror = forpy_initialize()

   ierror = get_sys_path(paths)
   ierror = paths%append(".")

   ierror = import_py(pytorch2fortran, "pytorch2fortran")
   ierror = print_py(pytorch2fortran)
   
   !character (len=255) :: cwd
   

   !call getcwd(cwd)
   
   ! open (10, file = trim(cwd)//'/data/data.dat', status = 'old')
   
   
   !open(2,file=trim(cwd)//'/mod_param_text_files/w0.txt')
   !open(2,file='w0.txt')
   !read(2,*) w1
   ierror = tuple_create(args,1)
   ierror = args%setitem(0,0)
   ierror = call_py(return_obj, pytorch2fortran, "wb_out", args)
   ierror = cast(w0_py, return_obj)
   ierror = w0_py%get_data(w1, order='C')
   call args%destroy
   call return_obj%destroy
   
   !open(3,file='b0.txt')
   !read(3,*) b1
   ierror = tuple_create(args,1)
   ierror = args%setitem(0,1)
   ierror = call_py(return_obj, pytorch2fortran, "wb_out", args)
   ierror = cast(b0_py, return_obj)
   ierror = b0_py%get_data(b1, order='C')
   call args%destroy
   call return_obj%destroy

   !open(4,file='w1.txt')
   !read(4,*) w2
   ierror = tuple_create(args,1)
   ierror = args%setitem(0,2)
   ierror = call_py(return_obj, pytorch2fortran, "wb_out", args)
   ierror = cast(w1_py, return_obj)
   ierror = w1_py%get_data(w2, order='C')
   call args%destroy
   call return_obj%destroy
   
   !open(5,file=trim(cwd)//'/mod_param_text_files/b1.txt')
   !open(15,file='b1.txt')
   !read(15,*) b2 
   ierror = tuple_create(args,1)
   ierror = args%setitem(0,3)
   ierror = call_py(return_obj, pytorch2fortran, "wb_out", args)
   ierror = cast(b1_py, return_obj)
   ierror = b1_py%get_data(b2, order='C')
   call args%destroy
   call return_obj%destroy
   
   !open(16,file='w2.txt')
   !read(16,*) w3
   !close(6)
   ierror = tuple_create(args,1)
   ierror = args%setitem(0,4)
   ierror = call_py(return_obj, pytorch2fortran, "wb_out", args)
   ierror = cast(w2_py, return_obj)
   ierror = w2_py%get_data(w3, order='C')
   call args%destroy
   call return_obj%destroy
   
   !open(7,file='b2.txt')
   !read(7,*) b3
   ierror = tuple_create(args,1)
   ierror = args%setitem(0,5)
   ierror = call_py(return_obj, pytorch2fortran, "wb_out", args)
   ierror = cast(b2_py, return_obj)
   ierror = b2_py%get_data(b3, order='C')
   call args%destroy
   call return_obj%destroy

 
   x1(1)=30.0   ! latitude
   x1(2)=-50.0  ! heat flux
   x1(3)=0.3    ! wind stress (friction velocity)
   x1(4)=-100   ! boundary layer depth
   

   
   ! assigning l, h, \tau, hbl 
   
   x2=matmul(x1,w1)
   x2=x2+b1
   call relu(x2,64)
   
   x3=matmul(x2,w2)
   x3=x3+b2
   call relu(x3,64)   
      
   y=matmul(x3,w3)
   y=y+b3
   

   
   print*,' model output is >', y

   call pytorch2fortran%destroy
   call paths%destroy
  
   call forpy_finalize
  
end program main
 
subroutine relu(x,m)
      
      integer, intent(in) :: m
      real, dimension (m), intent(inout) :: x
     
      integer :: i
      
      do i=1,m 
         if (x(i).lt.0) then
            x(i)=0 
             
         end if
         
      end do
end subroutine relu

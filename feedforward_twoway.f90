program main
   use forpy_mod
   use iso_fortran_env, only: real64
   implicit none
   
   integer :: ierror
   type(module_py) :: f2p2f
   type(list) :: paths
   type(ndarray) :: w0_py,w1_py
   type(object) :: return_obj
   type(tuple) :: args

   real(kind=real64), dimension(:,:), pointer :: w1
   
   real(kind=real64), dimension(6,4) :: w0 
   real(kind=real64) :: wmin 
   w0 = 1.0
   print*,' create a matrix >'
   print*, w0

   ierror = forpy_initialize()

   ierror = get_sys_path(paths)
   ierror = paths%append(".")

   ierror = import_py(f2p2f, "f2p2f")
   ierror = print_py(f2p2f)

   ierror = ndarray_create(w0_py, w0)
   
   ierror = tuple_create(args,1)
   ierror = args%setitem(0,w0_py)
   ierror = call_py(return_obj, f2p2f, "wb_out", args)
   ierror = cast(w1_py, return_obj)
   ierror = w1_py%get_data(w1)
   if (ierror/=0) then; call err_print; endif
   call args%destroy
   call return_obj%destroy
   call w1_py%destroy
   call w0_py%destroy
   
   print*,' transfer back to fortran >'
   print*, w1
   wmin = minval(abs(w1-w0))
   print*,' Difference before and after passing into Python >',wmin

   call f2p2f%destroy
   call paths%destroy
  
   call forpy_finalize
  
end program main

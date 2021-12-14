program main
   implicit none
   
   real, dimension(4, 64) :: w1
   real, dimension(64) :: b1
   real, dimension(64,64) :: w2
   real, dimension(64) :: b2
   real, dimension(64,16) :: w3
   real, dimension(16) :: b3
   

   
   real, dimension(4)  :: x1 ! input vector
   real, dimension(64) :: x2 ! hidden layer 1
   real, dimension(64) :: x3 ! hidden layer 2
   real, dimension(16) :: y  ! output vector
   
   integer :: i
   
   !character (len=255) :: cwd
   

   !call getcwd(cwd)
   
   ! open (10, file = trim(cwd)//'/data/data.dat', status = 'old')
   
   
   !open(2,file=trim(cwd)//'/mod_param_text_files/w0.txt')
   open(2,file='w0.txt')
   read(2,*) w1
   
   open(3,file='b0.txt')
   read(3,*) b1
   
   open(4,file='w1.txt')
   read(4,*) w2
   
   !open(5,file=trim(cwd)//'/mod_param_text_files/b1.txt')
   open(15,file='b1.txt')
   read(15,*) b2 
   
   open(16,file='w2.txt')
   read(16,*) w3
   !close(6)
   
   open(7,file='b2.txt')
   read(7,*) b3

 
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

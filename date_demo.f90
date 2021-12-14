program date_demo
   use forpy_mod
   implicit none
 
   integer :: ierror
   type(module_py) :: datetime
   type(object) :: date, today, today_str
   character(len=:), allocatable :: today_fortran
 
   ! Python:
   ! import datetime
   ! date = datetime.date
   ! today = date.today()
   ! today_str = today.isoformat()
   ! print("Today is ", today_str)
 
   ierror = forpy_initialize()
   ierror = import_py(datetime, "datetime")
   ierror = datetime%getattribute(date, "date")
 
   ierror = call_py(today, date, "today")
   ierror = call_py(today_str, today, "isoformat")
   ierror = cast(today_fortran, today_str)
 
   write(*,*) "Today is ", today_fortran
 
   call datetime%destroy
   call date%destroy
   call today%destroy
   call today_str%destroy
 
   call forpy_finalize
 
 end program
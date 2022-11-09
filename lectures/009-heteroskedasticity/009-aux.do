**


reg personal_income  education  i_female

reg personal_income  education  i_female, mse1

reg personal_income  education  i_female, mse

** mse1 and mce are the same thing.


reg personal_income  education  i_female, mse2

** MacKinnon-White:

reg personal_income  education  i_female, r

** same thing.

reg personal_income  education  i_female, vce(robust)





** BP test


reg personal_income  education  i_female


estat hettest


reg personal_income  education  i_female, vce(hc2)

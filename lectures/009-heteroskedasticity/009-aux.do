**


reg personal_income  education  i_female


** MacKinnon-White:

reg personal_income  education  i_female, r

** same thing.

reg personal_income  education  i_female, vce(robust)





** BP test


reg personal_income  education  i_female


estat hettest


reg personal_income  education  i_female, vce(hc2)

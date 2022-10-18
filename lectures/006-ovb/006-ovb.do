*-----------------------------------------------------------------------*
*												                        *
*												                        *
*                     EC 339: APPLIED ECONOMETRICS                      *    
*												                        *
*  Prof. Santetti									                    *
*-----------------------------------------------------------------------*



*------------------------------------------------------*
*         OMITTED VARIABLES BIAS IN PRACTICE           *
*------------------------------------------------------*


* Whenever using Stata, your first step should always be
* setting your working directory (that is, where your data files)
* will come from, and where you will save your work.

* In the top left corner, simply go to "File" > "Change Working Directory" > and choose
* your desired folder. Your data files should be there as well,
* so Stata can find and import it.


**------------------------------------------------------------------------




clear


use mroz_data





estat ovtest

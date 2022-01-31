# Robot-order-workflow
RoboCorp Certification Level II

This workflow downloads and reads a csv file and inputs order lines to a website. 

## Rules for the robot

- The robot should use the orders file (.csv ) and complete all the orders in the file. :heavy_check_mark:
- Only the robot is allowed to get the orders file. You may not save the file manually on your computer. :heavy_check_mark:
- The robot should save each order HTML receipt as a PDF file. :heavy_check_mark:
- The robot should save a screenshot of each of the ordered robots. :heavy_check_mark:
- The robot should embed the screenshot of the robot to the PDF receipt. :heavy_check_mark: *It does do this but the end result could be prettier*
- The robot should create a ZIP archive of the PDF receipts (one zip archive that contains all the PDF files). Store the archive in the output directory. :heavy_check_mark:
- The robot should complete all the orders even when there are technical failures with the robot order website. :heavy_check_mark:
- The robot should read some data from a local vault. :heavy_check_mark:
- The robot should use an assistant to ask some input from the human user, and then use that input some way.  :heavy_check_mark:
- The robot should be available in public GitHub repository. :heavy_check_mark:
- Store the local vault file in the robot project repository so that it does not require manual setup. :thinking: *(I am not 100% my solution meets this criteria...)*
- It should be possible to get the robot from the public GitHub repository and run it without manual setup. :thinking: *(I am not 100% my solution meets this criteria...)*


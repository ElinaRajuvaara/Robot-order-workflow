*** Settings ***
Documentation     Orders robots from RobotSpareBin Industries Inc.
...               Saves the order HTML receipt as a PDF file.
...               Saves the screenshot of the ordered robot.
...               Embeds the screenshot of the robot to the PDF receipt.
...               Creates ZIP archive of the receipts and the images.
Library           RPA.Browser.Selenium
Library           RPA.HTTP
Library           RPA.Tables
Library           RPA.PDF
Library           RPA.FileSystem
Library           RPA.Archive
Library           RPA.Dialogs
Library           RPA.Robocorp.Vault

*** Variables ***
${TEMP_OUTPUT_DIRECTORY}=    ${CURDIR}${/}temp
${RECEIPTS_TEMP_OUTPUT_DIRECTORY}=    ${CURDIR}${/}receipts

*** Tasks ***
Orders robots Orders robots from RobotSpareBin Industries Inc
    Set up directories
    ${orderFile_url}=    Collect Url from user
    ${orders}=    Get orders    ${orderFile_url}
    Open the robot order website
    FOR    ${row}    IN    @{orders}
        Close pop-up
        Fill the form    ${row}
        Wait Until Keyword Succeeds    5x    3s    Preview the robot
        Wait Until Keyword Succeeds    5x    3s    Submit the order
        ${pdf}=    Store the receipt as a PDF file    ${row}
        ${screenshot}=    Take a screenshot of the robot    ${row}
        Embed the robot screenshot to the receipt PDF file    ${screenshot}    ${pdf}    ${row}
        Go to order another robot
    END
    [Teardown]    Close the Browser
    Create Zip file of the receipts
    Cleanup temporary directories

*** Keywords ***
Set up directories
    Create Directory    ${TEMP_OUTPUT_DIRECTORY}
    Create Directory    ${RECEIPTS_TEMP_OUTPUT_DIRECTORY}

Open the robot order website
    ${secret}=    Get Secret    orderFile
    Open Chrome Browser    ${secret}[url]    maximized=True

Collect Url from user
    Add text Input    url    label=file url
    ${response}=    Run dialog
    [Return]    ${response.url}

Get orders
    [Arguments]    ${orderFile_url}
    Download    ${orderFile_url}    overwrite=True
    ${orders}=    Read table from CSV    orders.csv
    [Return]    ${orders}

Close pop-up
    Click Button    css:button[class="btn btn-dark"]

Fill the form
    [Arguments]    ${row}
    Wait Until Element Is Visible    id:head
    Select From List By Value    id:head    ${row}[Head]
    Select Radio Button    body    ${row}[Body]
    Input Text    //input[@placeholder="Enter the part number for the legs"]    ${row}[Legs]
    Input Text    id:address    ${row}[Address]

Preview the robot
    Click Button    id:preview

Submit the order
    Click Button    id:order
    Page Should Contain Element    id:receipt

Store the receipt as a PDF file
    [Arguments]    ${row}
    Wait Until Element Is Visible    id:receipt
    ${pdf}=    Get Element Attribute    id:receipt    outerHTML
    Html To Pdf    ${pdf}    ${TEMP_OUTPUT_DIRECTORY}${/}Order ${row}[Order number].pdf
    [Return]    ${TEMP_OUTPUT_DIRECTORY}${/}Order ${row}[Order number].pdf

Take a screenshot of the robot
    [Arguments]    ${row}
    Screenshot    id:robot-preview-image    ${TEMP_OUTPUT_DIRECTORY}${/}Order ${row}[Order number].PNG
    [Return]    ${TEMP_OUTPUT_DIRECTORY}${/}Order ${row}[Order number].PNG

Embed the robot screenshot to the receipt PDF file
    [Arguments]    ${pdf}    ${screenshot}    ${row}
    ${files}=    Create List
    ...    ${pdf}
    ...    ${screenshot}
    Add Files To Pdf    ${files}    ${RECEIPTS_TEMP_OUTPUT_DIRECTORY}${/}Order ${row}[Order number].pdf

Go to order another robot
    Click Button    id:order-another

Create Zip file of the receipts
    ${zip_file_name}=    Set Variable    ${OUTPUT_DIR}/PDFs.zip
    Archive Folder With Zip
    ...    ${RECEIPTS_TEMP_OUTPUT_DIRECTORY}
    ...    ${zip_file_name}

Cleanup temporary directories
    Remove Directory    ${TEMP_OUTPUT_DIRECTORY}    True
    Remove Directory    ${RECEIPTS_TEMP_OUTPUT_DIRECTORY}    True

Close the Browser
    Close Browser

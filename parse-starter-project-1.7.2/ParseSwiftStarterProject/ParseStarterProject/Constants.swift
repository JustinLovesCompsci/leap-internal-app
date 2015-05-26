//
//  Constants.swift
//  Leap Internal
//
//  Created by Justin (Zihao) Zhang on 5/10/15.
//  Copyright (c) 2015 Justin Zhang. All rights reserved.
//

import Foundation

let DEFAULT_TAB							= 0

/* User Category */
let PF_IS_EXEC                          = 1
let PF_IS_MENTOR                        = 2
let PF_IS_STUDENT_REP                   = 3

/* Installation */
let PF_INSTALLATION_CLASS_NAME			= "_Installation"           //	Class name
let PF_INSTALLATION_OBJECTID			= "objectId"				//	String
let PF_INSTALLATION_USER                = "User"                    //  Pointer

/* User */
let PF_USER_CLASS_NAME					= "_User"                   //	Class name
let PF_USER_OBJECTID					= "objectId"				//	String
let PF_USER_USERNAME					= "username"				//	String
let PF_USER_PASSWORD					= "password"				//	String
let PF_USER_NAME                        = "Name"                    //  String
let PF_USER_EMAIL                       = "email"                   //  String
let PF_USER_CATEGORY                    = "Category"                //  Number
let PF_USER_NAME_LOWER_CASE             = "LowerCaseName"           //  String

/* Todos */
let PF_TODOS_SUMMARY                    = "Summary"                 //  String
let PF_TODOS_DESCRIPTION                = "Description"             //  String
let PF_TODOS_DUE_DATE                   = "DueDate"                 //  Date
let PF_TODOS_CREATED_AT                 = "createdAt"               //  Date
let PF_TODOS_UPDATED_AT                 = "updatedAt"               //  Date
let PF_TODOS_CREATED_BY_PERSON          = "createdByPerson"         //  String
let PF_TODOS_CREATED_BY_EMAIL           = "createdByEmail"          //  String

/* ExecTodos */
let PF_EXEC_TODOS_CLASS_NAME            = "ExecTodos"               //  Class name
let PF_EXEC_TODOS_SUMMARY               = "Summary"                 //  String
let PF_EXEC_TODOS_DESCRIPTION           = "Description"             //  String
let PF_EXEC_TODOS_DUE_DATE              = "DueDate"                 //  Date
let PF_EXEC_TODOS_CREATED_AT            = "createdAt"               //  Date
let PF_EXEC_TODOS_UPDATED_AT            = "updatedAt"               //  Date
let PF_EXEC_TODOS_CREATED_BY_PERSON     = "createdByPerson"         //  String
let PF_EXEC_TODOS_CREATED_BY_EMAIL      = "createdByEmail"          //  String

/* GenTodos */
let PF_GEN_TODOS_CLASS_NAME             = "GenTodos"                //  Class name
let PF_GEN_TODOS_SUMMARY                = "Summary"                 //  String
let PF_GEN_TODOS_DESCRIPTION            = "Description"             //  String
let PF_GEN_TODOS_DUE_DATE               = "DueDate"                 //  Date
let PF_GEN_TODOS_CREATED_AT             = "createdAt"               //  Date
let PF_GEN_TODOS_UPDATED_AT             = "updatedAt"               //  Date
let PF_GEN_TODOS_CREATED_BY_PERSON      = "createdByPerson"         //  String
let PF_GEN_TODOS_CREATED_BY_EMAIL       = "createdByEmail"          //  String

/* Financial Records */
let PF_RECORD_SUMMARY                    = "Summary"                 //  String
let PF_RECORD_CREATED_AT                 = "createdAt"               //  Date
let PF_RECORD_UPDATED_AT                 = "updatedAt"               //  Date
let PF_RECORD_START_DATE                 = "StartDate"               //  Date
let PF_RECORD_END_DATE                   = "EndDate"                 //  Date
let PF_RECORD_USER_LIST                  = "UserList"                //  Array
let PF_RECORD_AMOUNT                     = "Amount"                  //  Number
let PF_RECORD_CREATED_BY                 = "createdBy"               //  String
let PF_RECORD_CONTACT_EMAIL              = "ContactEmail"            //  String

/* Gains */
let PF_GAINS_CLASS_NAME                 = "Gains"                   //  Class name
let PF_GAINS_SUMMARY                    = "Summary"                 //  String
let PF_GAINS_CREATED_AT                 = "createdAt"               //  Date
let PF_GAINS_UPDATED_AT                 = "updatedAt"               //  Date
let PF_GAINS_START_DATE                 = "StartDate"               //  Date
let PF_GAINS_END_DATE                   = "EndDate"                 //  Date
let PF_GAINS_USER_LIST                  = "UserList"                //  Array
let PF_GAINS_AMOUNT                     = "Amount"                  //  Number
let PF_GAINS_CREATED_BY                 = "createdBy"               //  String
let PF_GAINS_CONTACT_EMAIL              = "ContactEmail"            //  String

/* Losses */
let PF_LOSSES_CLASS_NAME                 = "Losses"                  //  Class name
let PF_LOSSES_SUMMARY                    = "Summary"                 //  String
let PF_LOSSES_CREATED_AT                 = "createdAt"               //  Date
let PF_LOSSES_UPDATED_AT                 = "updatedAt"               //  Date
let PF_LOSSES_START_DATE                 = "StartDate"               //  Date
let PF_LOSSES_END_DATE                   = "EndDate"                 //  Date
let PF_LOSSES_USER_LIST                  = "UserList"                //  Array
let PF_LOSSES_AMOUNT                     = "Amount"                  //  Number
let PF_LOSSES_CREATED_BY                 = "createdBy"               //  String
let PF_LOSSES_CONTACT_EMAIL              = "ContactEmail"            //  String

/* Reimburse */
let PF_REIMBURSE_CLASS_NAME              = "Reimburse"               //  Class name
let PF_REIMBURSE_SUMMARY                 = "Summary"                 //  String
let PF_REIMBURSE_CREATED_AT              = "createdAt"               //  Date
let PF_REIMBURSE_UPDATED_AT              = "updatedAt"               //  Date
let PF_REIMBURSE_START_DATE              = "StartDate"               //  Date
let PF_REIMBURSE_END_DATE                = "EndDate"                 //  Date
let PF_REIMBURSE_USER_LIST               = "UserList"                //  Array
let PF_REIMBURSE_AMOUNT                  = "Amount"                  //  Number
let PF_REIMBURSE_CREATED_BY              = "createdBy"               //  String
let PF_REIMBURSE_CONTACT_EMAIL           = "ContactEmail"            //  String

/* Financials */
let TOTAL_GAIN                           = "Total Gains"
let TOTAL_LOSS                           = "Total Losses"
let TOTAL_REIMBURSE                      = "Total Reimburse"
let TOTAL_NET                            = "Net Income"

/* General Profile */
let NAME                                 = "Name"
let EMAIL                                = "Email"
let PASSWORD                             = "Password"

/* New ToDo */
let NEW_TODO_SUMMARY                     = "New ToDo"

/* Edit Record */
let RECORD_SUMMARY                          = "Summary"
let RECORD_START_DATE                       = "Start Date"
let RECORD_END_DATE                         = "End Date"
let RECORD_USER_LIST                        = "Recipients"
let RECORD_AMOUNT                           = "Amount"
let RECORD_EMAIL                            = "Contact Email"

/* New Record */
let DEFAULT_RECORD_SUMMARY                  = "New Record"

/* Todos Action Buttons */
let SAVE_TO_CALENDAR                        = " Save to Calendar"
let ASK_QUESTION                            = " Ask a Question"

/* Todos Row Display */
let TODOS_DISPLAY_SUMMARY                   = "Summary"
let TODOS_DISPLAY_DUE_DATE                  = "Due By"
let TODOS_DISPLAY_CREATED_PERSON            = "Created By"
let TODOS_DISPLAY_CONTACT_EMAIL             = "Contact"

/* Email Choices */
let ADMIN_EMAIL                             = "admin@leap-usa.com"
let MANAGE_EMAIL                            = "management@leap-usa.com"
let SALES_EMAIL                             = "mentors@leap-usa.com"
let SERVICE_EMAIL                           = "service@leap-usa.com"
let MARKETING_EMAIL                         = "marketing@leap-usa.com"


/* Local DataStore Tag */
let TODO_DATA_TAG                               = "ToDoTag"
let MY_RECORDS_TAG                              = "RecordTag"

/* Email Tag */
let QUESTION_EMAIL_TAG                      = "[LEAP-Question]"

/* Notification Channels */
let EXEC_CHANNEL                        = "Execs"
let MENTORS_CHANNEL                     = "Mentors"
let STUDENT_REP_CHANNEL                 = "StudentReps"
let PF_CHANNEL                          = "channels"

/* Notification data fields */
let PUSH_FIELD_ID               = "id"
let PUSH_FIELD_TYPE             = "type"
let PUSH_FIELD_ACTION           = "action"
let PUSH_FIELD_ACTION_UPDATE    = "Update"
let PUSH_FIELD_ACTION_DELETE    = "Delete"

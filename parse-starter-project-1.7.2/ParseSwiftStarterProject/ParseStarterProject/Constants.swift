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
let PF_TYPE_EXEC                          = "exec"
let PF_TYPE_MENTOR                        = "mentor"
let PF_TYPE_STUDENT_REP                   = "studentRep"

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
let PF_USER_TYPES                       = "Types"                   //  String Array
let PF_USER_NAME_LOWER_CASE             = "LowerCaseName"           //  String

/* Todos */
let PF_TODOS_CLASS_NAME                 = "GenTodos"
let PF_TODOS_SUMMARY                    = "Summary"                 //  String
let PF_TODOS_DESCRIPTION                = "Description"             //  String
let PF_TODOS_DUE_DATE                   = "DueDate"                 //  Date
let PF_TODOS_CREATED_AT                 = "createdAt"               //  Date
let PF_TODOS_UPDATED_AT                 = "updatedAt"               //  Date
let PF_TODOS_CREATED_BY_EMAIL           = "createdByEmail"          //  String
let PF_TODOS_USER_LIST                  = "UserList"                //  Array
let PF_TODOS_TYPE                       = "Type"                    //  String
let PF_TODOS_OBJECT_ID                  = "objectId"                //  String
let PF_TODOS_CREATOR                    = "Creator"                 //  Pointer

/* Financial Records */
let PF_RECORD_SUMMARY                    = "Summary"                 //  String
let PF_RECORD_CREATED_AT                 = "createdAt"               //  Date
let PF_RECORD_UPDATED_AT                 = "updatedAt"               //  Date
let PF_RECORD_START_DATE                 = "StartDate"               //  Date
let PF_RECORD_END_DATE                   = "EndDate"                 //  Date
let PF_RECORD_USER_LIST                  = "UserList"                //  Array
let PF_RECORD_AMOUNT                     = "Amount"                  //  Number
let PF_RECORD_CONTACT_EMAIL              = "ContactEmail"            //  String
let PF_RECORD_TYPE                       = "Type"                    //  String
let PF_RECORD_CREATOR                    = "Creator"                 //  Pointer
let PF_RECORD_CLASS_NAME                 = "Record"

/* Assignee Type */
let TO_ALL_TYPE                         = "To All"
let TO_EXEC_TYPE                        = "To Exec"
let TO_STUDENT_REPS_TYPE                = "To High School Reps"
let TO_MENTORS_TYPE                     = "To Mentors"
let TO_SELECT_TYPE                      = "Select Multiple"

/* Record Type */
let GAIN_RECORD_TYPE                    = "gain"
let LOSS_RECORD_TYPE                    = "loss"
let REIMBURSE_RECORD_TYPE               = "reimburse"
let LOSS_CANCEL_RECORD_TYPE             = "lossCancel"

/* Financials */
let TOTAL_GAIN                           = "Total Gains"
let TOTAL_LOSS                           = "Total Losses"
let TOTAL_REIMBURSE                      = "Total Reimburse"
let TOTAL_LOSS_CANCEL                    = "罚款抵用劵"
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
let RECORD_EMAIL                            = "Contact"
let RECORD_DELETE_ACTION                    = "Delete"
let RECORD_ASK_QUESTION_ACTION              = "Ask Questions"

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
let FINANCE_EMAIL                           = "finance@leap-usa.com"
let DEVELOPMENT_EMAIL                       = "development@leap-usa.com"

/* Local DataStore Tag */
let TODO_DATA_TAG                               = "ToDoTag"
let MY_RECORDS_TAG                              = "RecordTag"

/* Email Tag */
let QUESTION_EMAIL_TAG                      = "[LEAP] Question:"

/* Notification Channels */
let EXEC_CHANNEL                        = "Execs"
let MENTORS_CHANNEL                     = "Mentors"
let STUDENT_REP_CHANNEL                 = "StudentReps"
let BROADCAST_CHANNEL                   = ""
let PF_CHANNEL                          = "channels"

/* Notification data fields */
let PUSH_FIELD_ID               = "id"
let PUSH_FIELD_TYPE             = "type"
let PUSH_FIELD_ACTION           = "action"
let PUSH_FIELD_ACTION_UPDATE    = "Update"
let PUSH_FIELD_ACTION_DELETE    = "Delete"

/* Cloud Functions */
let CLOUD_SEND_EMAIL            = "SendEmail"

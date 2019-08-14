FUNCTION ZT32_76_STUDENT_C.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(SKILLS_LIST) TYPE  ZT32_76_STUDENT_SKILL_T OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN) TYPE  BAPIRET2
*"  CHANGING
*"     VALUE(STUDENT) TYPE  ZAPP_STUDENT_S
*"----------------------------------------------------------------------
  DATA: LS_STUDENT TYPE ZSTUDENTS.


  IF STUDENT-FIRST_NAME IS INITIAL OR STUDENT-LAST_NAME IS INITIAL.
    RETURN-TYPE = 'E'.
    RETURN-MESSAGE = 'First and Last Name are mandatory'.
    RETURN.
  ENDIF.

  STUDENT-CREATED_ON = SY-DATUM.
  STUDENT-CREATED_AT = SY-UZEIT.
  STUDENT-CREATED_BY = SY-UNAME.

  " give back the ID so GW can call READ operation afterwards
  STUDENT-ID = CL_SYSTEM_UUID=>CREATE_UUID_C32_STATIC( ).

  MOVE-CORRESPONDING STUDENT TO LS_STUDENT.

  INSERT ZSTUDENTS FROM LS_STUDENT.

  IF SY-SUBRC IS NOT INITIAL.
    RETURN-TYPE = 'E'.
    RETURN-MESSAGE = 'Student not inserted'.
    RETURN.
  ENDIF.

  CALL FUNCTION 'ZT32_76_STUDENT_SKL_C'
    EXPORTING
      ID          = LS_STUDENT-ID    " Student ID
      SKILLS_LIST = SKILLS_LIST      " Table of structure
    IMPORTING
      RETURN      = RETURN.           " Return Parameter

  IF SY-SUBRC IS NOT INITIAL.
    RETURN-TYPE = 'E'.
    RETURN-MESSAGE = 'Skill not inserted at student'.
    ROLLBACK WORK.
    RETURN.
  ENDIF.
  COMMIT WORK.

*  clear STUDENT-id.

ENDFUNCTION.
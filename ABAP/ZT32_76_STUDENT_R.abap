FUNCTION ZT32_76_STUDENT_R.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(ID) TYPE  ZOVLY_STUDENT_ID
*"  EXPORTING
*"     VALUE(STUDENT) TYPE  ZAPP_STUDENT_S
*"     VALUE(SKILLS_LIST) TYPE  ZT32_76_STUDENT_SKILL_T
*"  TABLES
*"      RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------


  CALL FUNCTION 'Z_APP_STUDENTS_R'
    EXPORTING
      ID     = ID       " Student ID
    IMPORTING
      ENTITY = STUDENT  " Entity Type: Student
      RETURN = RETURN.  " Return Parameter

  IF SY-SUBRC IS NOT INITIAL.
    RETURN.
  ELSE.
    CALL FUNCTION 'ZT32_76_STUDENT_SKL_Q'
      EXPORTING
        ID     = ID          " Student ID
      IMPORTING
        ENTITY = SKILLS_LIST " Table of structure
        RETURN = RETURN.     " Return Parameter
  ENDIF.

ENDFUNCTION.
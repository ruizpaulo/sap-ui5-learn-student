FUNCTION ZT32_76_STUDENT_Q.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(TOP) TYPE  BAPIMAXROW OPTIONAL
*"     VALUE(IT_RA_USER_NAME) TYPE  ZAPP_USER_NAME_RT OPTIONAL
*"     VALUE(IT_RA_CREATED_ON) TYPE  ZT26_OVLYAPP_CREATED_ON_RT_52
*"       OPTIONAL
*"  EXPORTING
*"     VALUE(STUDENT) TYPE  ZAPP_STUDENT_T
*"     VALUE(SKILLS_LIST) TYPE  ZT32_76_STUDENT_SKILL_T
*"----------------------------------------------------------------------
  CALL FUNCTION 'Z_APP_STUDENTS_Q_F'
    EXPORTING
      TOP              = TOP              " Maximum number of lines of hits
      IT_RA_USER_NAME  = IT_RA_USER_NAME  " Filtro por username
      IT_RA_CREATED_ON = IT_RA_CREATED_ON " Range Table: Created On
    IMPORTING
      ENTITY           = STUDENT.                 " Entity Type: Student

  IF STUDENT IS NOT INITIAL.
    SELECT *
    FROM ZSTUDENTS_SKILLS
    INTO TABLE @DATA(LT_STUDENT_SKILLS)
    FOR ALL ENTRIES IN @STUDENT
    WHERE STUDENT = @STUDENT-ID.
      SKILLS_LIST = CORRESPONDING #( LT_STUDENT_SKILLS ).
  ENDIF.




ENDFUNCTION.
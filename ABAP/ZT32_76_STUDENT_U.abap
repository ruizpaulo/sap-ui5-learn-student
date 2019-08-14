FUNCTION ZT32_76_STUDENT_U.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(STUDENT) TYPE  ZAPP_STUDENT_S
*"     VALUE(SKILLS_LIST) TYPE  ZT32_76_STUDENT_SKILL_T
*"  EXPORTING
*"     VALUE(RETURN) TYPE  BAPIRET2
*"----------------------------------------------------------------------
  DATA LS_STUDENT_OLD TYPE ZAPP_STUDENT_S.

  CALL FUNCTION 'Z_APP_STUDENTS_R'
    EXPORTING
      ID     = STUDENT-ID              " Student ID
    IMPORTING
      ENTITY = LS_STUDENT_OLD.         " Entity Type: Student

  STUDENT-CREATED_BY = LS_STUDENT_OLD-CREATED_BY.
  STUDENT-CREATED_ON = LS_STUDENT_OLD-CREATED_ON.
  STUDENT-CREATED_AT = LS_STUDENT_OLD-CREATED_AT.

  "Altera os dados básicos do aluno
  CALL FUNCTION 'Z_APP_STUDENTS_U'
    EXPORTING
      ENTITY = STUDENT             " Entity Type: Student
    IMPORTING
      RETURN = RETURN.              " Return Parameter
  IF SY-SUBRC IS NOT INITIAL.
    RETURN.
  ENDIF.

  "Exclui todas as skills do aluno
  CALL FUNCTION 'ZT32_76_STUDENT_SKL_D'
    EXPORTING
      ID     = STUDENT-ID     " Student ID
    IMPORTING
      RETURN = RETURN.         " Return Parameter
  IF SY-SUBRC IS NOT INITIAL.
    ROLLBACK WORK.
    RETURN.
  ENDIF.

  "Cria as skills novamente
  CALL FUNCTION 'ZT32_76_STUDENT_SKL_C'
    EXPORTING
      ID          = STUDENT-ID                " Student ID
      SKILLS_LIST = SKILLS_LIST                " Table of structure
    IMPORTING
      RETURN      = RETURN.                  " Return Parameter
  IF SY-SUBRC IS NOT INITIAL.
    ROLLBACK WORK.
    RETURN.
  ENDIF.

ENDFUNCTION.
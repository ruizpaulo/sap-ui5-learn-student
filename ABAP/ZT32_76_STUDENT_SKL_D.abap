FUNCTION ZT32_76_STUDENT_SKL_D.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(ID) TYPE  ZOVLY_STUDENT_ID
*"  EXPORTING
*"     VALUE(RETURN) TYPE  BAPIRET2
*"----------------------------------------------------------------------

  IF ID IS NOT INITIAL.
    DELETE FROM ZSTUDENTS_SKILLS WHERE STUDENT EQ ID.
  ENDIF.

  IF SY-SUBRC IS NOT INITIAL.
    RETURN-TYPE = 'W'.
    RETURN-MESSAGE = 'Student does not have skills to delete'.
    RETURN.
  ENDIF.



ENDFUNCTION.
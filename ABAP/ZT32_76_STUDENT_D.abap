FUNCTION ZT32_76_STUDENT_D.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(ID) TYPE  ZOVLY_STUDENT_ID
*"  TABLES
*"      RETURN STRUCTURE  BAPIRET2
*"--------------------------------------------------------------------

  IF ID IS NOT INITIAL.
    CALL FUNCTION 'ZT32_76_STUDENT_SKL_D'
      EXPORTING
        ID     = ID            " Student ID
      TABLES
        RETURN = RETURN.        " Return Parameter
    DELETE FROM ZSTUDENTS WHERE ID EQ ID.
    IF SY-SUBRC IS NOT INITIAL.
      ROLLBACK WORK.
      RETURN-TYPE = 'E'.
      RETURN-MESSAGE = 'Student does not have skills to delete'.
      RETURN.
    ENDIF.
  ENDIF.


ENDFUNCTION.
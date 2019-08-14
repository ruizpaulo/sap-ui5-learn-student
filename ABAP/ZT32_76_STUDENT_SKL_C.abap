FUNCTION ZT32_76_STUDENT_SKL_C.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(ID) TYPE  ZOVLY_STUDENT_ID
*"     VALUE(SKILLS_LIST) TYPE  ZT32_76_STUDENT_SKILL_T
*"  EXPORTING
*"     VALUE(RETURN) TYPE  BAPIRET2
*"----------------------------------------------------------------------
  DATA LS_STD_SKL TYPE ZSTUDENTS_SKILLS.

  FIELD-SYMBOLS: <fs_skills> LIKE LINE OF SKILLS_LIST.

  IF SKILLS_LIST IS NOT INITIAL.
    LOOP AT SKILLS_LIST ASSIGNING <fs_skills>.
        MOVE-CORRESPONDING <fs_skills> TO LS_STD_SKL.
        LS_STD_SKL-STUDENT = ID.
        INSERT ZSTUDENTS_SKILLS FROM LS_STD_SKL.
        IF SY-SUBRC IS NOT INITIAL.
          ROLLBACK WORK.
          RETURN-TYPE = 'E'.
          RETURN-MESSAGE = 'Skill not inserted at student'.
          RETURN.
        ENDIF.
    ENDLOOP.
  ENDIF.

*  clear STUDENT-id.

ENDFUNCTION.
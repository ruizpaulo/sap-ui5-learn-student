FUNCTION ZT32_76_STUDENT_SKL_Q.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(ID) TYPE  ZOVLY_STUDENT_ID
*"  EXPORTING
*"     VALUE(ENTITY) TYPE  ZT32_76_STUDENT_SKILL_T
*"     VALUE(RETURN) TYPE  BAPIRET2
*"----------------------------------------------------------------------

  SELECT
    STUDENT,
    SKILL
    FROM
      ZSTUDENTS_SKILLS
    INTO TABLE @DATA(IT_ENTITY)
    WHERE
      STUDENT = @ID.

    ENTITY[] = IT_ENTITY[].

  ENDFUNCTION.
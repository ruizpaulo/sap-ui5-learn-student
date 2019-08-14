  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY.
        DATA: BEGIN OF LS_STUDENTS_SKILLS.
        INCLUDE TYPE ZCL_ZT32_76_STUDENT_MPC=>TS_STUDENT.

    "Esse nome precisa ser exatamente igual ao Navgation Proprties da Entity
    DATA: TOSTUDENTSKILLS TYPE ZCL_ZT32_76_STUDENT_MPC=>TT_STUDENTSKILL,
          END OF LS_STUDENTS_SKILLS.

    DATA: LV_ENTITY_SET_NAME   TYPE /IWBEP/MGW_TECH_NAME,
          LS_STUDENT           TYPE ZAPP_STUDENT_S,
          LT_STUDENT_SKILL     TYPE ZT32_76_STUDENT_SKILL_T,
          LS_STUDENT_SKILL     TYPE ZT32_76_STUDENT_SKILL_S,
          LS_REQ_STUDENT_SKILL TYPE ZCL_ZT32_76_STUDENT_MPC=>TS_STUDENTSKILL,
          LT_RETURN            TYPE STANDARD TABLE OF BAPIRET2,
          LS_RETURN            TYPE BAPIRET2.

* Pega o nome do Entity Set
    LV_ENTITY_SET_NAME     = IO_TECH_REQUEST_CONTEXT->GET_ENTITY_SET_NAME( ).

* Para o caso de haver mais de uma entity set no projeto
    CASE LV_ENTITY_SET_NAME.
      WHEN 'Students'.

*   Pega o Student e a lista de skills do http request para ser criado
        IO_DATA_PROVIDER->READ_ENTRY_DATA( IMPORTING ES_DATA = LS_STUDENTS_SKILLS ).
        MOVE-CORRESPONDING LS_STUDENTS_SKILLS TO LS_STUDENT.

*   Popula a tabela de items para passar para a BAPI posteriormente
        LOOP AT LS_STUDENTS_SKILLS-TOSTUDENTSKILLS INTO LS_REQ_STUDENT_SKILL.
          LS_STUDENT_SKILL-SKILL = LS_REQ_STUDENT_SKILL-SKILL.
          APPEND LS_STUDENT_SKILL TO LT_STUDENT_SKILL.
        ENDLOOP.


        IF LS_STUDENT-ID IS INITIAL.
*       Chama a FM de criação de student
          CALL FUNCTION 'ZT32_76_STUDENT_C'
            EXPORTING
              SKILLS_LIST = LT_STUDENT_SKILL
            IMPORTING
              RETURN      = LS_RETURN
            CHANGING
              STUDENT     = LS_STUDENT.
        ELSE.
*       Chama a FM de update de student
          CALL FUNCTION 'ZT32_76_STUDENT_U'
            EXPORTING
              STUDENT    =    LS_STUDENT              " Entity Type: Student
              SKILLS_LIST =    LT_STUDENT_SKILL       " Table of structure
            IMPORTING
              RETURN      =    LS_RETURN              " Return Parameter
            .


        ENDIF.

        IF LS_RETURN IS NOT INITIAL.
          APPEND LS_RETURN TO LT_RETURN.
          CALL METHOD MO_CONTEXT->GET_MESSAGE_CONTAINER( )->ADD_MESSAGES_FROM_BAPI(
               EXPORTING
                    IT_BAPI_MESSAGES          = LT_RETURN
                    IV_DETERMINE_LEADING_MSG  = /IWBEP/IF_MESSAGE_CONTAINER=>GCS_LEADING_MSG_SEARCH_OPTION-FIRST ).
          RAISE EXCEPTION TYPE /IWBEP/CX_MGW_BUSI_EXCEPTION
            EXPORTING
              TEXTID            = /IWBEP/CX_MGW_BUSI_EXCEPTION=>BUSINESS_ERROR
              MESSAGE_CONTAINER = MO_CONTEXT->GET_MESSAGE_CONTAINER( ).

        ENDIF.

*   Lê os valores criados do Student e dos Skills
        CLEAR: LT_STUDENT_SKILL[],LS_STUDENTS_SKILLS.
        CALL FUNCTION 'ZT32_76_STUDENT_R'
          EXPORTING
            ID          = LS_STUDENT-ID            " Student ID
          IMPORTING
            STUDENT     = LS_STUDENT               " Entity Type: Student
            SKILLS_LIST = LT_STUDENT_SKILL         " Table of structure
          TABLES
            RETURN      = LT_RETURN.               " Return Parameter

        MOVE-CORRESPONDING LS_STUDENT TO LS_STUDENTS_SKILLS.
        APPEND LINES OF LT_STUDENT_SKILL TO LS_STUDENTS_SKILLS-TOSTUDENTSKILLS.

*     Transfere esses valores para o retorno
        COPY_DATA_TO_REF( EXPORTING IS_DATA = LS_STUDENTS_SKILLS
                           CHANGING  CR_DATA = ER_DEEP_ENTITY ).

    ENDCASE.
  endmethod.
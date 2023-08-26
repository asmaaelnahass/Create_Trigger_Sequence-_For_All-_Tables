
/*# First project
__________
dynamic sql : write ddl statements inside plsql code
__________
create seq, trg pairs on all tables in the schema
    - using loop
    - drop all sequences first in the loop
    - replace any triggers if found 
    - set sequences to start with max id + 1
        for each table
    ignore increment by [ only increment by 1 ]
    - donot forget to choose the PK column for each table*/
    SET SERVEROUTPUT ON
DECLARE
    CURSOR trg_seq_cursor IS
     SELECT ucc.constraint_name, ucc.table_name, ucc.column_name, utc.data_type
          FROM  user_objects     uo,
            user_constraints   uc,
               user_cons_columns  ucc,
               user_tab_columns   utc
           WHERE     ucc.constraint_name = uc.constraint_name
               AND ucc.table_name = uc.table_name
               AND ucc.table_name = uo.object_name
               AND ucc.table_name = utc.table_name
               AND utc.column_name = ucc.column_name
               AND uc.constraint_type = 'P'
               AND uo.object_type = 'TABLE'
               AND utc.data_type = 'NUMBER';

    v_start_with   NUMBER;
BEGIN
    FOR trg_seq_record IN trg_seq_cursor
    LOOP
       
        FOR all_seq IN (SELECT sequence_name
                  FROM user_sequences
                 WHERE sequence_name = trg_seq_record.TABLE_NAME || '_SEQ')
        LOOP
            -- If sequence exists, drop it
            IF all_seq.sequence_name IS NOT NULL
            THEN
              
                EXECUTE IMMEDIATE 'DROP SEQUENCE ' || all_seq.sequence_name;
            END IF;
        END LOOP;


      
        EXECUTE IMMEDIATE   'SELECT NVL(MAX('|| trg_seq_record.column_name || '), 0) + 1 
        FROM ' || trg_seq_record.table_name  INTO v_start_with;

        EXECUTE IMMEDIATE   'CREATE SEQUENCE ' || trg_seq_record.TABLE_NAME || '_SEQ
      START WITH ' || v_start_with  || ' increment by 1';

        EXECUTE IMMEDIATE   'CREATE OR REPLACE TRIGGER ' || trg_seq_record.TABLE_NAME  || '_TRG
            BEFORE INSERT OR UPDATE
            ON ' || trg_seq_record.TABLE_NAME || 
           ' FOR EACH ROW
            BEGIN
                :new.'  || trg_seq_record.COLUMN_NAME || ' := ' || trg_seq_record.TABLE_NAME  || '_SEQ.nextval;
                end;';
    END LOOP;
END;                                  
 --departments
 --employees
 show errors;
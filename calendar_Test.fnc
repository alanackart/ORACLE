CREATE OR REPLACE FUNCTION calendar_Test(
                I_country in CALENDAR.COUNTRY%type default 'cn', 
                I_year_month in CALENDAR.YEAR_MONTH%TYPE DEFAULT '201812',
                I_kind in CALENDAR.Kind%TYPE DEFAULT '2'
        )RETURN CALENDAR_DAY_STRING AS

    PRAGMA AUTONOMOUS_TRANSACTION;
    lc_ret    CALENDAR_DAY_STRING := CALENDAR_DAY_STRING();
    V_DAY  VARCHAR2(31);
    V_err_msg varchar(255);
    V_err_num NUMBER;
    v_num     INTEGER;
/*    cursor cal_cur is
            select *
            from Calendar t
            where t.country = I_country
            and t.year_month = I_year_month
            and t.kind = I_kind;*/
        BEGIN
          begin
          V_NUM :=  2/ 0;
           EXCEPTION WHEN OTHERS THEN V_NUM := 1;
           end;
      select t.Days into  V_DAY
            from Calendar t
            where t.country = I_country
            and t.year_month = I_year_month
            and t.kind = I_kind;
            lc_ret.EXTEND;
      lc_ret(lc_ret.LAST) := CALENDAR_DAYS(V_DAY);
      return(lc_ret);
  EXCEPTION
  WHEN OTHERS THEN
    V_err_num     := SQLCODE;
    V_err_msg     := SUBSTR(SQLERRM, 1, 100);
    lc_ret.EXTEND;
    lc_ret(lc_ret.LAST) := CALENDAR_DAYS('ERROR');
    return(lc_ret);
    END;
/

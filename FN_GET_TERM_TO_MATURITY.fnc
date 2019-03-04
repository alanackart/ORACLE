create or replace function FN_GET_TERM_TO_MATURITY
(
I_SECURITY_ID              in  security.security_code%TYPE,
I_PROCESS_DATE               in  system_data.business_date%TYPE default ' '
)
return char AS
V_err_msg                    varchar(255);
V_err_num                    NUMBER;
V_MATURITY_DATE              SECURITY.MATURITY_DATE%type;
V_CNT                        int;
V_RET                        char(7);
V_YEAR                       int;
V_M                          int;
V_N                          int;
V_TRADE_DATE                 system_data.business_date%type;
V_DATE_TMP                   system_data.business_date%type;
myEx                         exception;
begin
   if trim(I_SECURITY_ID) is null then
     raise myEx;
   end if;
   if(trim(I_PROCESS_DATE) is null) then
      /*select business_date into V_TRADE_DATE from system_data;*/
      SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') into V_TRADE_DATE FROM DUAL;
   else
      V_TRADE_DATE:=I_PROCESS_DATE;
   end if;
   
   
   select count(*) into V_CNT from security t where trim(t.security_code) = trim(I_SECURITY_ID); 
  
   if V_CNT = 1 THEN
      select t.maturity_date into V_MATURITY_DATE  from security t where trim(t.security_code) = trim(I_SECURITY_ID);
      if V_TRADE_DATE > V_MATURITY_DATE then
         raise myEx;
        end if;
    /* get year difference */
    V_YEAR := 0;
    V_DATE_TMP := V_TRADE_DATE;
   while V_MATURITY_DATE >= to_char(add_months(to_date(V_DATE_TMP,'YYYYMMDD'), 12),'YYYYMMDD') loop
     V_YEAR := V_YEAR + 1;
     V_DATE_TMP := to_char(add_months(to_date(V_DATE_TMP,'YYYYMMDD'), 12),'YYYYMMDD');
   END LOOP;
   if V_YEAR >= 1 then
      select to_date(V_MATURITY_DATE,'yyyymmdd')-to_date(V_DATE_TMP,'yyyymmdd') into V_N from dual;/*do this, so xxxD won't greater than 365D*/
      else
         select to_date(V_MATURITY_DATE,'yyyymmdd')-to_date(V_TRADE_DATE,'yyyymmdd') into V_N from dual;
     end if;
     
/*get year difference, end*/
     select lpad(to_char(V_YEAR),2,'0') || 'Y' || lpad(to_char(V_N),3,'0') || 'D' into V_RET from dual;  
     return V_RET;   
     else
       raise myEx;
   end if;
    
   
  
EXCEPTION
  when myEx then
   V_err_num      := SQLCODE;
   V_err_msg      := SUBSTR(SQLERRM, 1, 100);
   V_RET:=NULL;
   return(V_RET);
   WHEN OTHERS THEN
   V_err_num      := SQLCODE;
   V_err_msg      := SUBSTR(SQLERRM, 1, 100);
   V_RET:=NULL;
   return(V_RET);
end;
/

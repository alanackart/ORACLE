create or replace function valid_user_pass(
in_user_id         in char,
in_random_password in char
)return boolean
is
v_cus_num number(5);
v_max_len int := 0; --rule 2
v_min_len int := 0; --rule 3
v_real_len int;
v_cnt_letter int :=  0;
v_cnt_digit int :=  0;
v_is_up_lo char(1) := 'N';
v_cnt_real_letter int := 0;
v_cnt_real_digit int :=0;
v_cnt_real_up int :=0;
v_cnt_real_lo int :=0;

begin

    select t.cus_number into v_cus_num  from wuser t where t.user_id = in_user_id;
    select nvl(max(length(in_random_password)), 0) into v_real_len from dual; -- real length of pass
    select nvl(max(t.limit), 0) into v_max_len from user_pwd_rule t where t.status = 'A' and t.rule_id = '00002'and t.cus_number = v_cus_num;
       if (v_max_len <> 0) then
         if v_real_len > v_max_len then
          return false;
         end if;
       end if;
     --------------------- 
  
    select nvl(max(t.limit), 0) into v_min_len from user_pwd_rule t where t.status = 'A' and t.rule_id = '00003'and t.cus_number = v_cus_num;
    if (v_min_len <> 0) then
       if v_real_len < v_min_len then
        return false;
       end if;
     end if;
    --------------------- 
    /*
    select  length ( regexp_replace('asdad123', '[0-9]', '')  ) from dual;
select  length ( regexp_replace('asdad123', '[a-zA-Z]', '')  ) from dual;
    */
    select nvl(max(t.limit), 0) into v_cnt_letter from user_pwd_rule t where t.status = 'A' and t.rule_id = '00004'and t.cus_number = v_cus_num;
      if(v_cnt_letter <> 0) then
         select  regexp_count(in_random_password, '[a-zA-Z]')   into v_cnt_real_letter from dual;
               if v_cnt_real_letter < v_cnt_letter then
            return false;
            end if;
       end if;
    ---------------------   
        select nvl(max(t.limit), 0) into v_cnt_digit from user_pwd_rule t where t.status = 'A' and t.rule_id = '00005'and t.cus_number = v_cus_num;
      if(v_cnt_digit <> 0) then
         select  regexp_count(in_random_password, '[0-9]') into v_cnt_real_digit from dual;
               if v_cnt_real_digit < v_cnt_digit then
            return false;
            end if;
       end if;
    
      ---------------------   
      select nvl(max(t.limit), 'N') into v_is_up_lo from user_pwd_rule t where t.status = 'A' and t.rule_id = '00006'and t.cus_number = v_cus_num;
      if(v_is_up_lo <> 'N') then
         select  regexp_count(in_random_password, '[A-Z]' ) into v_cnt_real_up from dual;
         select  regexp_count(in_random_password, '[a-z]' ) into v_cnt_real_lo from dual;
         if ( v_cnt_real_up*v_cnt_real_lo <= 0) then
            return false;
            end if;
       end if;
       
      return true;
     exception
      when others then
           return false;
  end valid_user_pass;
/

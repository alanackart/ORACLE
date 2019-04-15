
-- Created on 2019/4/11 by HP 
declare 
  -- Local variables here
  i integer;
  j integer;
  str clob;
  str1 varchar2(4000);
  str2 varchar2(4000);
  tmp  varchar2(4000);
  part1  varchar2(4000);
  part2  varchar2(4000);
  
begin
  -- Test statements here
  str := '<?xml version="1.0" encoding="UTF-8" ?><Page><Mode>A</Mode><CUS_NUMBER>581</CUS_NUMBER><STRATEGY_ID>L_01_01_07</STRATEGY_ID><SEQ></SEQ><IS_USE>Y</IS_USE><CUS_ACTION_RANGE>RFQ</CUS_ACTION_RANGE><TYPE_RANGE></TYPE_RANGE><TTM_RANGE_S></TTM_RANGE_S><TTM_RANGE_E></TTM_RANGE_E><TYPE_TTM_RANGE_S></TYPE_TTM_RANGE_S><TYPE_TTM_RANGE_E></TYPE_TTM_RANGE_E><ERROR_LEVEL>1</ERROR_LEVEL><FROM_TIME>0900</FROM_TIME><TO_TIME>1630</TO_TIME><CUS_DESC>123</CUS_DESC><ACTION_TYPE>3</ACTION_TYPE><GRP_ROLE>L</GRP_ROLE><IS_TYPE_RANGE>Y</IS_TYPE_RANGE><IS_TTM_RANGE>N</IS_TTM_RANGE><DEALER>00188</DEALER><PARAM_LIST>123</PARAM_LIST></Page>';

--dbms_output.put_line(str);
i := dbms_lob.instr(str, '<PARAM_LIST>') ;
i := i-1;
dbms_lob.read(str , i, 1,   part1);
dbms_output.put_line( 'part1=' || part1  );
tmp := TRIM(GET_XML_VALUE(part1, 'IS_USE'));
dbms_output.put_line( 'IS_USE=' || tmp  );
j := 4000;
i := i+1;
dbms_lob.read(str , j, i,   part2);
dbms_output.put_line( 'part2=' || part2  );
tmp := TRIM(GET_XML_VALUE(part2, 'PARAM_LIST'));
dbms_output.put_line( 'PARAM_LIST=' || tmp  );
  
end;

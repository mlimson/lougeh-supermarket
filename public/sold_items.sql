create view sold_items (stransactionid, customercode, itemcode, itemdescription, sqty, saleprice, timestamp) as
SELECT st.stransactionid,
       st.customercode,
       i.itemcode,
       i.itemdescription,
       sl.sqty,
       sl.saleprice,
       st."timestamp"
FROM salestransaction st
         LEFT JOIN salesline sl ON st.stransactionid = sl.stransactionid
         LEFT JOIN item i ON sl.itemcode = i.itemcode;

alter table sold_items
    owner to postgres;


create view sold_items(itemcode, itemdescription, saleprice, timestamp) as
SELECT i.itemcode,
       i.itemdescription,
       sl.saleprice,
       st."timestamp"
FROM salestransaction st
         LEFT JOIN salesline sl ON st.stransactionid = sl.stransactionid
         LEFT JOIN item i ON sl.itemcode = i.itemcode;

alter table sold_items
    owner to postgres;


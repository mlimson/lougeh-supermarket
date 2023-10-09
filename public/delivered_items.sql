create view delivered_items(dtransactionid, itemcode, itemdescription, dqty, itemcost, timestamp) as
SELECT dt.dtransactionid,
       i.itemcode,
       i.itemdescription,
       dl.dqty,
       dl.itemcost,
       dt."timestamp"
FROM deliverytransaction dt
         LEFT JOIN deliveryline dl ON dt.dtransactionid = dl.dtransactionid
         LEFT JOIN item i ON dl.itemcode = i.itemcode
ORDER BY dt."timestamp";

alter table delivered_items
    owner to postgres;


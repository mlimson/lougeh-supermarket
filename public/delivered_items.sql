create view delivered_items(itemcode, itemdescription, itemcost, timestamp) as
SELECT i.itemcode,
       i.itemdescription,
       dl.itemcost,
       dt."timestamp"
FROM deliverytransaction dt
         LEFT JOIN deliveryline dl ON dt.dtransactionid = dl.dtransactionid
         LEFT JOIN item i ON dl.itemcode = i.itemcode;

alter table delivered_items
    owner to postgres;


create view inventorystatus (itemcode, itembarcode, itemdescription, itemstock, averagecost, averageprice) as
SELECT i.itemcode,
       i.itembarcode,
       i.itemdescription,
       iv.itemstock,
       avg(d.itemcost)::numeric(10, 2)  AS averagecost,
       avg(s.saleprice)::numeric(10, 2) AS averageprice
FROM inventory iv
         JOIN item i ON iv.itemcode = i.itemcode
         JOIN deliveryline d ON i.itemcode = d.itemcode
         JOIN salesline s ON i.itemcode = s.itemcode
GROUP BY i.itemcode, i.itembarcode, i.itemdescription, iv.itemstock;

alter table inventorystatus
    owner to postgres;


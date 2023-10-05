create view inventorydata(itemcode, itemdescription, itembarcode, itemstock) as
SELECT iv.itemcode,
       i.itemdescription,
       i.itembarcode,
       iv.itemstock
FROM inventory iv
         JOIN item i ON iv.itemcode = i.itemcode
WHERE iv.itemstock > 0;

alter table inventorydata
    owner to postgres;


create view itemdata(itemcode, itemdescription, itembarcode, description) as
SELECT DISTINCT it.itemcode,
                it.itemdescription,
                it.itembarcode,
                u.description
FROM item it
         LEFT JOIN itemuom iu ON it.itemcode = iu.itemcode
         LEFT JOIN inventory i ON iu.uniqueid = i.itemuomid
         LEFT JOIN uom u ON iu.uomid = u.uomid
ORDER BY it.itemcode;

alter table itemdata
    owner to postgres;


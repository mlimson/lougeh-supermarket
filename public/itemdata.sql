create view itemdata(itemcode, itemdescription, itembarcode, uomid, description, itemprice) as
SELECT DISTINCT it.itemcode,
                it.itemdescription,
                it.itembarcode,
                u.uomid,
                u.description,
                it.itemprice
FROM item it
         LEFT JOIN itemuom iu ON it.itemcode = iu.itemcode
         LEFT JOIN inventory i ON iu.uniqueid = i.itemuomid
         LEFT JOIN uom u ON iu.uomid = u.uomid
ORDER BY it.itemcode;

alter table itemdata
    owner to postgres;


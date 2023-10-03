create view topfiveitemsold(itemcode, itemdescription, "Total Quantity") as
SELECT i.itemcode,
       i.itemdescription,
       sum(sl.sqty) AS "Total Quantity"
FROM salesline sl
         LEFT JOIN item i ON sl.itemcode = i.itemcode
GROUP BY i.itemcode, i.itemdescription, sl.sqty
ORDER BY (sum(sl.sqty)) DESC
LIMIT 5;

alter table topfiveitemsold
    owner to postgres;


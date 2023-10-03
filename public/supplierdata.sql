create view supplierdata(suppliercode, companyname, sstreet, scity, scountry, contactnumber) as
SELECT DISTINCT suppliers.suppliercode,
                suppliers.companyname,
                sa.sstreet,
                sa.scity,
                sa.scountry,
                sc.contactnumber
FROM suppliers
         LEFT JOIN supplieraddress sa ON suppliers.suppliercode = sa.suppliercode
         LEFT JOIN suppliercontact sc ON sa.saddressid = sc.saddressid
GROUP BY suppliers.suppliercode, suppliers.companyname, sa.sstreet, sa.scity, sa.scountry, sc.contactnumber
ORDER BY suppliers.suppliercode;

alter table supplierdata
    owner to postgres;


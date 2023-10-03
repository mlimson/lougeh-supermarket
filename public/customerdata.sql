create view customerdata (customercode, firstname, lastname, cstreet, ccity, ccountry, ccontactnumber) as
SELECT DISTINCT customers.customercode,
                customers.firstname,
                customers.lastname,
                ca.cstreet,
                ca.ccity,
                ca.ccountry,
                cc.ccontactnumber
FROM customers
         LEFT JOIN customeraddress ca ON customers.customercode = ca.customercode
         LEFT JOIN customercontact cc ON ca.caddressid = cc.caddressid
GROUP BY customers.customercode, customers.firstname, customers.lastname, ca.cstreet, ca.ccity, ca.ccountry,
         cc.ccontactnumber
ORDER BY customers.customercode;

alter table customerdata
    owner to postgres;


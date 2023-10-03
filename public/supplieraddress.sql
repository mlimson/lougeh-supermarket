create table supplieraddress
(
    saddressid   serial
        primary key,
    suppliercode integer
        references suppliers,
    sstreet      varchar(50),
    scity        varchar(50),
    scountry     varchar(50)
);

alter table supplieraddress
    owner to postgres;


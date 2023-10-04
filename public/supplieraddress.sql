create table supplieraddress
(
    saddressid   serial
        primary key,
    suppliercode integer
        references suppliers,
    sstreet      varchar(255),
    scity        varchar(255),
    scountry     varchar(255)
);

alter table supplieraddress
    owner to postgres;


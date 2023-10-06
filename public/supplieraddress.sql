create table supplieraddress
(
    saddressid   serial
        primary key,
    suppliercode integer      not null
        references suppliers,
    sstreet      varchar(255),
    scity        varchar(255),
    scountry     varchar(255) not null
);

alter table supplieraddress
    owner to postgres;


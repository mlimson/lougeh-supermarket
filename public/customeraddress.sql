create table customeraddress
(
    caddressid   serial
        primary key,
    customercode integer
        references customers,
    cstreet      varchar(50),
    ccity        varchar(50),
    ccountry     varchar(50)
);

alter table customeraddress
    owner to postgres;


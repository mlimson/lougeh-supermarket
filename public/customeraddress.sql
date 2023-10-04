create table customeraddress
(
    caddressid   serial
        primary key,
    customercode integer
        references customers,
    cstreet      varchar(255),
    ccity        varchar(255),
    ccountry     varchar(255)
);

alter table customeraddress
    owner to postgres;


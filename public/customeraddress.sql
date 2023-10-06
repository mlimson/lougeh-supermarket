create table customeraddress
(
    caddressid   serial
        primary key,
    customercode integer      not null
        references customers,
    cstreet      varchar(255),
    ccity        varchar(255),
    ccountry     varchar(255) not null
);

alter table customeraddress
    owner to postgres;

